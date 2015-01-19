#!/bin/bash
#
# Set up Ruby on Rails on Fedora 21
#
# adapted from https://gorails.com/setup/ubuntu/14.10

### needed for readline support in ruby
echo "Installing readline-devel for readline support in ruby..."
sudo dnf install readline-devel
echo ""

### install rbenv
echo "Installing rbenv..."
git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' | tee --append $HOME/.bashrc >> /dev/null
echo 'eval "$(rbenv init -)"' | tee --append $HOME/.bashrc >> /dev/null
exec $SHELL
echo ""

### clone the ruby source
echo "Cloning ruby source..."
git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' | tee --append $HOME/.bashrc >> /dev/null
exec $SHELL
echo ""

### disable building/installing gem docs locally
echo "Disabling local rdoc (just look up docs online)..."
echo "gem: --no-ri --no-rdoc" | tee --append $HOME/.gemrc >> /dev/null
echo ""

### build and install Ruby
RUBYVERSION=2.1.2
echo "Building Ruby ${RUBYVERSION}..."
rbenv install ${RUBYVERSION}
rbenv global ${RUBYVERSION}
echo ""

### install mariadb (mysql)
echo "Installing MariaDB (SQL)..."
sudo dnf install mariadb-server
echo ""

### enable mariadb service
echo "Enabling MariaDB systemd services..."
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
echo ""

### configure git
echo "Configuring git..."
git config --global color.ui true
git config --global push.default simple
echo ""
echo "Please enter your name as you would like it displayed in commits:"
read gitname
git config --global user.name "${gitname}"
echo ""
echo "Please enter your Github username:"
read gituser
git config --global user.email "${gituser}@users.noreply.github.com"
echo ""

### done
echo "Rails setup complete."
echo ""
