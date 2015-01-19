#!/bin/bash
#
## This script sets up an environment for a Windows 7 VM running under Vagrant.

VAGRANTDIR=$HOME/win7vagrant
mkdir -p ${VAGRANTDIR}

### install Virtualbox and Vinagre (RDP client)
sudo dnf install -y VirtualBox kmod-VirtualBox vinagre

### install vagrant
sudo dnf install -y http://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.1_x86_64.rpm

### plop in Vagrantfile
echo '# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Do not touch unless you know what you are doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Every Vagrant virtual environment requires a box to build off of.
config.vm.box = "win7-20140822"
# CHANGME input URL to hosted win7.box
config.vm.box_url = "CHANGEME"
config.vm.communicator = "winrm"
config.vm.network :forwarded_port, host: 3399, guest: 3389
end' | tee $VAGRANT_DIR/Vagrantfile >> /dev/null

### done
echo "Setup nearly complete. Please edit Vagrantfile (CHANGEME), connect to"
echo "campus ethernet, and run:"
echo ""
echo "cd $HOME/win7vagrant && vagrant up && vagrant rdp"
echo ""
