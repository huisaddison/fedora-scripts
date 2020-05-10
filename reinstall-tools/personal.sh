#!/bin/bash
# for a fresh Fedora Workstation install; do not use on already-in-use systems

### remove stuff I don't need
sudo dnf erase -y abrt* bijiben cheese devassistant evolution gnome-boxes gnome-documents \
				libvirt* orca qemu* rhythmbox

### enable moar repos
sudo dnf install \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

### make sure everything's up-to-date
sudo dnf upgrade -y

### install drivers things
sudo dnf install -y exfat-utils fuse-exfat mesa-vdpau-drivers libtxc_dxtn \
			libva-vdpau-driver libvdpau-va-gl p7zip unrar vlc
# install powertop only if not a desktop

### terminal apps
sudo dnf install -y git gdb lynx powerline vim-enhanced tmux tmux-powerline \
    valgrind vim-plugin-powerline xclip
# sane vimrc
echo 'installing vim run commands...'
cat vimrc > $HOME/.vimrc
echo 'done!'

# install powerline for vim
sudo pip install powerline-status

# custom bash stuff
echo 'installing bash run commands...'
cat bashrc > $HOME/.bashrc
echo 'done!'

mkdir $HOME/repos
mkdir $HOME/repos/base16-gnome-terminal
git clone https://github.com/aaron-williamson/base16-gnome-terminal $HOME/repos/base16-gnome-terminal

# tmux configuration
echo 'source "/usr/share/tmux/powerline.conf"' | tee $HOME/.tmux.conf

# Pathogen plugin manager for vim
mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle && \
curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
mkdir $HOME/.vim/bundle/
git clone https://github.com/vimwiki/vimwiki.git $HOME/.vim/bundle/vimwiki
git clone https://github.com/lervag/vimtex.git $HOME/.vim./bundle/vimtex

# setup misc directory for vim
mkdir $HOME/.vim/backup
mkdir $HOME/.vim/undo

# setup directories for personal utils
mkdir $HOME/utils
mkdir $HOME/utils/bin
mkdir $HOME/utils/python

# set git-config
git config --global user.email "huisaddison@users.noreply.github.com"
git config --global user.name "Addison Hu"
git config --global push.default simple
git config --global color.ui true

### media libs
sudo dnf install -y gstreamer1-libav gstreamer1-plugins-ugly gstreamer1-plugins-bad-freeworld \
                    gstreamer1-plugins-bad-free

### LaTeX
sudo dnf install -y texlive-scheme-basic texlive-collection-mathextra texlive-algorithm2e texlive-bbm texlive-bbm-macros \
		    texlive-doublestroke texlive-framed texlive-titling texlive-units texlive-changepage texlive-tabu \
            texlive-datetime texlive-moderncv latexmk

## Some More LaTeX for making slides
sudo dnf install -y texlive-blkarray texlive-lastpage texlive-xetex texlive-xltxtra texlive-libertine

### general apps
sudo dnf install -y calibre deja-dup firewalld gimp \
                    keepassx \
                    R shotwell \
                    chromium \
                    snapd \
                    gnome-tweaks 


# git lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash


## TODO: pip install python apps



sudo dnf install -y openssl-devel libcurl-devel libxml2-devel


# dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
$HOME/.dropbox-dist/dropboxd

# spotify
sudo snap install spotify
                   
### GNOME tweaks
# TODO: Make sure this stuff actually does anything
sudo dnf install -y gnome-shell-extension-alternate-tab gnome-tweak-tool
# set global gtk3 dark theme
mkdir -p $HOME/.config/gtk-3.0
echo '[Settings]
gtk-application-prefer-dark-theme=1' | tee $HOME/.config/gtk-3.0/settings.ini
# display date in top bar of Shell
dconf write /org/gnome/desktop/interface/clock-show-date true
# set alt tab to switch applications
dconf write /org/gnome/desktop/wm/keybindings/switch-applications \
    "['<Alt>Tab']"
# set super tab to switch within application groups
dconf write /org/gnome/desktop/wm/keybindings/switch-group \
    "['<Super>Tab']"
# hide Terminal menu bar
dconf write /org/gnome/terminal/legacy/default-show-menubar false
# sane trackpad settings
dconf write /org/gnome/settings-daemon/peripherals/touchpad/natural-scroll true  # Mac-style scrolling
dconf write /org/gnome/settings-daemon/peripherals/touchpad/tap-to-click true
# disable autorun on media insertion
dconf write /org/gnome/desktop/media-handling/autorun-never true
# swap control and caps lock keys
dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:swapcaps']"
# resize GNOME's massive title bar
sudo sed -i "/title_vertical_pad/s/value=\"[0-9]\{1,2\}\"/value=\"0\"/g" \
			/usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml

### dconf tweaks
# shotwell
dconf write /org/yorba/shotwell/preferences/files/commit-metadata true
dconf write /org/yorba/shotwell/preferences/files/use-lowercase-filenames true
dconf write /org/yorba/shotwell/preferences/ui/use-24-hour-time true
dconf write /org/yorba/shotwell/preferences/ui/hide-photos-already-imported true

# shortcut for gnome-terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings\
    "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Ctrl><Alt>t' 


### firefox tweaks
## global extensions
sudo dnf install -y mozilla-https-everywhere
## local settings - set here to survive upgrades and not disturb other user accounts
# create local profile
firefox -CreateProfile default >> /dev/null
# grab firefox profile name
FF=`grep Path $HOME/.mozilla/firefox/profiles.ini | sed 's/Path\=//'`
FFPATH=$HOME/.mozilla/firefox/${FF}
# neuter the hazard of 'ctrl+q'
echo 'user_pref("browser.showQuitWarning", true);' | tee --append ${FFPATH}/prefs.js
# disable 'sponsored tiles'
echo 'user_pref("browser.newtabpage.directory.ping", "");' | tee --append ${FFPATH}/prefs.js
echo 'user_pref("browser.newtabpage.directory.source", "");' | tee --append ${FFPATH}/prefs.js
# set DONOTTRACK header
echo 'user_pref("privacy.donottrackheader.enabled", true);' | tee --append ${FFPATH}/prefs.js
# set userContent.css workaround for moz#70315
mkdir -p ${FFPATH}/chrome

### set locale
## localectl is system-wide? dconf is local

# automatically adjust time zone per network geo-lookup
dconf write /org/gnome/desktop/datetime/automatic-timezone true

### now reboot to save and load changes
reboot
