#!/bin/bash
# for a fresh Fedora 24 Workstation install; do not use on already-in-use systems

### remove stuff I don't need
sudo dnf erase -y abrt* bijiben cheese devassistant evolution gnome-boxes gnome-documents \
				libvirt* orca qemu* rhythmbox

### enable moar repos
sudo dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-24.noarch.rpm
sudo dnf install -y http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-24.noarch.rpm
sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo

### make sure everything's up-to-date
sudo dnf upgrade -y

### install drivers things
sudo dnf install -y exfat-utils fuse-exfat mesa-vdpau-drivers libtxc_dxtn \
			libva-vdpau-driver libvdpau-va-gl p7zip redshift unrar vlc
# install powertop only if not a desktop
# sudo dnf install -y powertop

# set redshift DISPLAY variable to built-in monitor per https://bbs.archlinux.org/viewtopic.php?pid=1447538#p1447538
mkdir -p $HOME/.config/systemd/user/redshift.service.d
# use DISPLAY=:1 for second display, :2 for third, etc
echo '[Service]
Environment=DISPLAY=:0' | tee $HOME/.config/systemd/user/redshift.service.d/display.conf

# enable redshift service
systemctl --user enable redshift.service
# enable powertop service - commented out because unnecessary on desktops
# sudo systemctl enable powertop.service

### terminal apps
sudo dnf install -y git lynx powerline vim-enhanced tmux tmux-powerline vim-plugin-powerline xclip
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
git clone https://github.com/chriskempson/base16-gnome-terminal $HOME/repos/base16-gnome-terminal

# tmux configuration
echo 'source "/usr/share/tmux/powerline.conf"' | tee $HOME/.tmux.conf

# Pathogen plugin manager for vim
mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle && \
curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
mkdir $HOME/.vim/bundle/base16-vim
git clone https://github.com/chriskempson/base16-vim.git $HOME/.vim/bundle/base16-vim
git clone https://github.com/vimwiki/vimwiki.git $HOME/.vim/bundle/vimwiki

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
		    texlive-doublestroke texlive-framed texlive-titling texlive-units texlive-changepage texlive-tabu

### general apps
# TODO: duplicity instead of deja-dup ?
sudo dnf install -y audacity calibre deja-dup epiphany firewalld gimp gnome-contacts \
                    gnome-music gnome-weather gnumeric keepassx okular powertop \
                    R shotwell shutter spotify-client 
                   
# Install Chrome
sudo dnf install -y 'https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm'

# Install Dropbox
curl 'https://www.dropbox.com/install?os=lnx' | sed 's/\<a/\n/g' | grep 'href="/download' \
			| grep fedora | grep x86_64 | awk -F'"' '{print "https://www.dropbox.com"$2}' | xargs sudo dnf install -y

# Install RStudio
curl 'https://www.rstudio.com/products/rstudio/download/' | grep Fedora \
			| grep 64-bit | grep rpm | awk -F'"' '{print $2}' | xargs sudo dnf install -y

### GNOME tweaks
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

### moar dconf tweaks
# shotwell
dconf write /org/yorba/shotwell/preferences/files/commit-metadata true
dconf write /org/yorba/shotwell/preferences/files/use-lowercase-filenames true
dconf write /org/yorba/shotwell/preferences/ui/use-24-hour-time true
dconf write /org/yorba/shotwell/preferences/ui/hide-photos-already-imported true

# shortcut for gnome-terminal
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Primary><Alt>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'gnome-terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Terminal'"


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
echo '/*
 * * Use this css file to eliminate problems in Firefox
 * * when using dark themes that create dark on dark
 * * input boxes, selection menus and buttons. Put this
 * * in the ../firefox/default/chrome folder or your
 * * individual user firefox profile chrome folder.
 * */
input {
//	border: 2px inset white;
	background-color: white;
	color: black;
	-moz-appearance: none !important;
}
textarea {
//	border: 2px inset white;
	background-color: white;
	color: black;
	-moz-appearance: none !important;
}
select {
	border: 2px inset white;
	background-color: white;
	color: black;
	-moz-appearance: none !important;
}
body {
	background-color: white;
	color: black;
	display: block;
	margin: 8px;
	-moz-appearance: none !important;
}' | tee ${FFPATH}/chrome/userContent.css

### set locale
## localectl is system-wide? dconf is local

# automatically adjust time zone per network geo-lookup
dconf write /org/gnome/desktop/datetime/automatic-timezone true

### now reboot to save and load changes
reboot
