#!/bin/sh

cleanup() {
    sudo apt-get -y update
    sudo apt-get -y dist-upgrade
    sudo apt-get -y -f install
    sudo apt-get -y autoremove
    sudo apt-get -y autoclean
    sudo apt-get -y clean
}

# fast-apt
sudo add-apt-repository -y ppa:saiarcot895/myppa
sudo apt-get -y update
sudo apt-get -y install apt-fast

# req to install
sudo apt-fast -y install cowsay dpkg curl

# mongodb package
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# repositories
sudo add-apt-repository -y ppa:caffeine-developers/ppa
sudo add-apt-repository -y ppa:videolan/stable-daily
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
sudo add-apt-repository -y ppa:cwchien/gradle
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer
sudo add-apt-repository -y ppa:webupd8team/sublime-text-2
sudo add-apt-repository -y ppa:webupd8team/java
sudo add-apt-repository -y ppa:me-davidsansome/clementine
sudo add-apt-repository -y ppa:transmissionbt/ppa
sudo add-apt-repository -y ppa:atareao/atareao
sudo add-apt-repository -y multiverse
sudo add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make
sudo apt-get -y install software-properties-common

sudo apt-get update

# codecs
sudo apt-get -y install ubuntu-restricted-extras libavcodec-extra ffmpeg x264 gstreamer0.10-ffmpeg libdvd-pkg

#APPEARANCE
# caffeine
sudo apt-get -y install caffeine
# myweather
sudo apt-get -y install my-weather-indicator
# shutter
sudo apt-get -y install shutter

#MEDIA
# vlc
sudo apt-get -y install vlc browser-plugin-vlc
# clementine player
sudo apt-get -y install clementine
# gMTP
sudo apt-get -y install gmtp
# gimp
sudo apt-get -y install gimp gimp-data gimp-plugin-registry gimp-data-extras

#INTERNET
# google chrome for amd64
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
sudo apt-get -y -f install
# gnome gdrive integration feature
sudo apt-get -y install gnome-control-center gnome-online-accounts
# skype
sudo apt-get -y install skype
# correct theme dependencies for skype 64bit
sudo apt-get -y install gtk2-engines-murrine:i386 gtk2-engines-pixbuf:i386
# transmisson
sudo apt-get -y install transmission minissdpd natpmp-utils

#PACKAGES
# synaptic
sudo apt-get -y install synaptic
# gdebi
sudo apt-get -y install gdebi

#SYSTEM
# grub customizer
sudo apt-get -y install grub-customizer
# bleachbit
sudo apt-get -y install bleachbit
# unity-tweak-tool
sudo apt-get -y install unity-tweak-tool
# rdp
sudo apt-get -y install remmina remmina-plugin-rdp
# virtualbox
sudo apt-get -y install virtualbox

#DEVELOPER TOOLS
# mongodb latest stable version
# --allow-unauthenticated only for Ubuntu 16.04
sudo apt-get install -y --allow-unauthenticated mongodb-org
# sublime2
sudo apt-get -y install sublime-text
# bless
sudo apt-get -y install bless
# ubuntu-make
sudo apt-get -y install ubuntu-make
# git
sudo apt-get -y install git
# java
sudo apt-get -y install oracle-java8-installer
# setting Java environment variables
sudo apt-get -y install oracle-java8-set-default
# scala
umake scala
# android studio && android sdk && android ndk
umake android --accept-license
# idea-ultimate
umake ide idea-ultimate
# clion
umake ide clion
# tomcat7
sudo apt-get -y install tomcat7
# build systems
sudo apt-get -y install maven
sudo apt-get -y install gradle

#Front-end
#linuxbrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
##dependencies
sudo apt-get install build-essential curl file git python-setuptools
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.profile
echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.profile
echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.profile
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
brew install node
npm install -g typescript
npm install -g @angular/cli



cleanup

cowsay "FINISHED"