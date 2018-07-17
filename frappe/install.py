import sys

from deploy import LocalDeploy

dependencies = [
    "pip install docker-compose",
    "pip install virtualenv"
]

param = str(sys.argv[1])
if param == 'localdev':
    deploy = LocalDeploy(dependencies)
    deploy.deploy()
elif param == 'run':
    deploy = LocalDeploy(dependencies)
    deploy.on_run()
