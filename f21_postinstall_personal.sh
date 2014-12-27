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
echo 'caption always
termcapinfo xterm*|rxvt*|kterm*|Eterm*|putty*|dtterm* ti@:te@
defscrollback 20736' > $HOME/.screenrc
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
dconf write /org/gnome/terminal/legacy/dark-theme true  # dark by default in 3.14 ?
dconf write /org/gnome/terminal/legacy/default-show-menubar false
dconf write /org/gnome/settings-daemon/peripherals/touchpad/natural-scroll true  # Mac-style scrolling
dconf write /org/gnome/settings-daemon/peripherals/touchpad/tap-to-click true
dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'us+mac')]"
#
## firefox tweaks
sudo dnf install -y mozilla-https-everywhere mozilla-noscript
echo 'pref("browser.showQuitWarning", true);' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js >> /dev/null  # neuter 'ctrl+q'
echo 'pref("browser.newtabpage.directory.ping", "");' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js >> /dev/null
echo 'pref("browser.newtabpage.directory.source", "");' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js >> /dev/null  # turn off sponsored tiles
### TODO: how do we set extension prefs?
#echo 'user_pref("noscript.global", true);' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js >> /dev/null  # set NoScript to global allow
#echo 'user_pref("noscript.ctxMenu", false);' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js  # disable NoScript context menu
#
## set locale
dconf write /system/locale/region "'en_CA.UTF-8'"
localectl set-locale LANG=en_CA.UTF-8  # TODO: insufficient
localectl set-x11-keymap us-mac mac  # redundant from dconf setting? probably not since dconf is per user
#
## games
sudo dnf install -y 0ad
#
## now reboot to save and load changes
reboot