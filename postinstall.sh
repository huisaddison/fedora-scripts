#!/bin/bash
#
# from a Fedora 21 Workstation base install
#
#
## remove stuff I don't need
sudo dnf erase -y abrt* bijiben cheese devassistant empathy evolution gnome-boxes gnome-clocks gnome-documents java* libreoffice* orca rhythmbox transmission-gtk
#
## enable moar repos
sudo dnf copr enable -y dgoerger/firefox-gtk3
sudo dnf copr enable -y petersen/pandoc
sudo yum-config-manager --add-repo=http://negativo17.org/repos/fedora-handbrake.repo
sudo dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-21.noarch.rpm
#
## make sure everything's up-to-date
sudo dnf upgrade -y
#
## hardware
sudo dnf install -y mesa-vdpau-drivers libva-vdpau-driver libvdpau-va-gl powertop redshift
mkdir -p $HOME/.config/autostart
echo "[Desktop Entry]
Name=redshift
GenericName=Redshift
Comment=Shift it red yo
Exec=redshift -l 41.3:-72.9  # New Haven, CT; geoclue lookup seems broken
Terminal=false
Type=Application
StartupNotify=false
MimeType=text/plain;
Icon=redshift
Categories=GNOME;GTK;Utility
X-GNOME-FullName=Redshift" > $HOME/.config/autostart/redshift.desktop
sudo systemctl enable powertop.service
#
## terminal apps
sudo dnf install -y git lynx pandoc screen transmission-cli vim-enhanced
echo 'set nocompatible
filetype off
syntax on
au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))' > $HOME/.vimrc
#
## media libs
sudo dnf install -y gstreamer1-libav gstreamer1-plugins-ugly gstreamer1-plugins-bad-freeworld \
                    gstreamer1-plugins-bad-free HandBrake-cli
#
## LaTeX - quite large so comment out if unneeded
sudo dnf install -y vim-latex vim-latex-doc texlive-collection-basic texlive-collection-fontsextra \
                    texlive-collection-fontsrecommended texlive-collection-langfrench \
                    texlive-collection-langgerman texlive-collection-langspanish \
                    texlive-collection-latexrecommended texlive-luatex texlive-xetex
#
## general apps
sudo dnf install -y calibre deja-dup epiphany firewalld geary gnome-contacts gnome-music \
                    gnome-weather gnumeric keepassx shotwell 
#
## GNOME tweaks
sudo dnf install -y gnome-shell-extension-alternate-tab gnome-tweak-tool
mkdir -p $HOME/.config/gtk-3.0
echo "[Settings]
gtk-application-prefer-dark-theme=1" > $HOME/.config/gtk-3.0/settings.ini  # gtk3 dark theme
dconf write /org/gnome/shell/enabled-extensions "['alternate-tab@gnome-shell-extensions.gcampax.github.com']"  # alt-tab to switch windows not apps
dconf write /org/gnome/terminal/legacy/dark-theme true
dconf write /org/gnome/terminal/legacy/default-show-menubar false
#
## firefox tweaks
sudo dnf install -y mozilla-https-everywhere mozilla-noscript
sudo echo 'pref("browser.showQuitWarning", true);' >> /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js  # neuter 'ctrl+q'
sudo echo 'pref("browser.newtabpage.directory.ping", "");' >> /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js
sudo echo 'pref("browser.newtabpage.directory.source", "");' >> /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js  # turn off sponsored tiles
sudo echo 'pref("noscript.global", true);' >> /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js  # set NoScript to global allow
sudo echo 'pref("noscript.ctxMenu", false);' >> /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js  # disable NoScript context menu
#
## set locale
localectl set-locale "LANG=en_CA.UTF-8" 
localectl set-keymap us-mac
#
## games
sudo dnf install -y 0ad
#
## now reboot to save and load changes
reboot