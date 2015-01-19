#!/bin/bash
#
# Set up Ruby on Rails on Fedora 21
#
# adapted from https://gorails.com/setup/ubuntu/14.10

### needed for readline support in ruby
sudo dnf install readline-devel

### install rbenv
git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' | tee --append $HOME/.bashrc
echo 'eval "$(rbenv init -)"' | tee --append $HOME/.bashrc
exec $SHELL

### clone the ruby source
git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' | tee --append $HOME/.bashrc
exec $SHELL

### build and install Ruby
rbenv install 2.1.2
rbenv global 2.1.2

### install mariadb (mysql)
sudo dnf install mariadb-server

### enable mariadb service
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
