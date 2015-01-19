#!/bin/bash
#
## This script sets up an environment for a Windows 7 VM running under Vagrant.

VAGRANTDIR=$HOME/winvagrant
mkdir -p ${VAGRANTDIR}

### install Virtualbox and Vinagre (RDP client)
sudo dnf install -y VirtualBox kmod-VirtualBox vinagre

### install vagrant
sudo dnf install -y http://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.1_x86_64.rpm

### read in URL to vagrant box
echo "Please provide the URL to the hosted vagrant box you wish"
echo "to use. If you do not yet know the URL, you will have to"
echo "edit ${VAGRANTDIR}/Vagrantfile to add the URL before use."
read boxurl

### plop in Vagrantfile
echo '# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Do not touch unless you know what you are doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Every Vagrant virtual environment requires a box to build off of.
config.vm.box = "winbox"
# CHANGME input URL to hosted win.box
config.vm.box_url = "${boxurl}"
config.vm.communicator = "winrm"
config.vm.network :forwarded_port, host: 3399, guest: 3389
end' | tee $VAGRANT_DIR/Vagrantfile >> /dev/null

### done
echo "Setup is complete. Please connect to campus ethernet and run:"
echo ""
echo "cd $HOME/winvagrant && vagrant up && vagrant rdp"
echo ""
