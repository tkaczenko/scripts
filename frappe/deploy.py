import os
import re
import shutil
import subprocess
from abc import ABCMeta, abstractmethod
from six import add_metaclass


@add_metaclass(ABCMeta)
class BaseDeploy:

    def __init__(self, dependencies=None,
                 to_clone_frappe_docker='git clone --depth 1 https://github.com/frappe/frappe_docker.git'):
        self.__cur_path = os.path.dirname(os.path.realpath(__file__))
        self.__to_clone_frappe_docker = to_clone_frappe_docker
        self.__dbench = '/frappe_docker/dbench'
        self.__dest_app_dir = '/frappe_docker/frappe-bench/apps/lms'
        self.__app_dir = '/lms'
        self.__dependencies = dependencies

    @abstractmethod
    def _fix_mysql_config(self):
        pass

    def deploy(self):
        self._on_pre_deploy()
        self._on_install_app()
        self.on_run()

    def _on_pre_deploy(self):
        self.__install_dependencies()
        self._call_shell_command(self.__to_clone_frappe_docker)
        self.__remove_erpnext()
        self._fix_mysql_config()

    def _on_install_app(self):
        os.chdir(self._process_dir('/frappe_docker'))
        self._call_shell_command('docker-compose up -d')
        self._call_shell_command('bash dbench init')
        os.chdir(self.__cur_path)
        self.__copy_lms()
        self._call_shell_command('docker exec -it frappe bash -c \"bench --site site1.local install-app lms\"')

    def on_run(self):
        os.chdir(self._process_dir('/frappe_docker'))
        self._call_shell_command('docker-compose start')
        self._call_shell_command('bash dbench -s')
        self._call_shell_command('bash dbench -c start')

    def __install_dependencies(self):
        for dependence in self.__dependencies:
            self._call_shell_command(dependence)

    def __remove_erpnext(self):
        util_path = self._process_dir(self.__dbench)
        input = open(util_path, 'r')
        output = open(util_path + 'updated', 'w')
        for line in input:
            if 'erpnext' not in line:
                output.write(line)
        input.close()
        output.close()
        os.rename(util_path + 'updated', util_path)

    def __copy_lms(self):
        app_dir = self._process_dir(self.__app_dir)
        dest_dir = self._process_dir(self.__dest_app_dir)
        shutil.copytree(app_dir, dest_dir)
        update_files_to_install_app = {
            self._process_dir('/frappe_docker/frappe-bench/sites/apps.txt'):
                '\nlms',
            self._process_dir('/frappe_docker/frappe-bench/env/lib/python2.7/site-packages/easy-install.pth'):
                '\n/home/frappe/frappe-bench/apps/lms'
        }
        for file in update_files_to_install_app:
            self._append_to_config(file, update_files_to_install_app[file])

    def _append_to_config(self, path, text):
        output = open(path, 'a')
        output.write(text)
        output.close()

    def _call_shell_command(self, command):
        pipe = subprocess.Popen(command, shell=True)
        pipe.wait()

    def _process_dir(self, dir):
        return self.__cur_path + dir


class LocalDeploy(BaseDeploy):

    def __init__(self, dependencies=None):
        BaseDeploy.__init__(self, dependencies)

    def _fix_mysql_config(self):
        statusProc = subprocess.Popen(['mysql', '--version'], stdout=subprocess.PIPE)
        ver = statusProc.stdout.read().strip()
        regex = re.compile(r"Ver\s(\d*)", re.IGNORECASE)
        version = int(regex.search(ver).group(1))
        if version > 8:
            myCnf = self._process_dir('/frappe_docker/conf/mariadb-conf.d/my.cnf')
            input = open(myCnf, 'r')
            output = open(myCnf + 'updated', 'w')
            for line in input:
                found = False
                for config in ['innodb-file-format=barracuda', 'innodb-large-prefix=1']:
                    if config in line:
                        found = True
                        break
                if not found:
                    output.write(line)
            input.close()
            output.close()
            os.rename(myCnf + 'updated', myCnf)
