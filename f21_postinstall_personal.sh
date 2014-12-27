#!/bin/bash
# from a fresh Fedora 21 Workstation install; not for already-in-use systems

### remove stuff I don't need
sudo dnf erase -y abrt* bijiben cheese devassistant empathy evolution gnome-boxes gnome-clocks gnome-documents java* libreoffice* orca rhythmbox transmission-gtk

### enable moar repos
sudo dnf copr enable -y dgoerger/firefox-gtk3
sudo dnf copr enable -y petersen/pandoc
sudo yum-config-manager --add-repo=http://negativo17.org/repos/fedora-handbrake.repo
sudo dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-21.noarch.rpm

### make sure everything's up-to-date
sudo dnf upgrade -y

### install drivers things
sudo dnf install -y mesa-vdpau-drivers libva-vdpau-driver libvdpau-va-gl powertop redshift
mkdir -p $HOME/.config/autostart
# set redshift autostart since `systemctl --user enable redshift.service` doesn't work rhbz#1174024
echo '[Desktop Entry]
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
X-GNOME-FullName=Redshift' > $HOME/.config/autostart/redshift.desktop
# enable powertop service
sudo systemctl enable powertop.service

### terminal apps
sudo dnf install -y git lynx pandoc screen transmission-cli vim-enhanced
# sane vimrc
echo 'set nocompatible
filetype off
syntax on
au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))' > $HOME/.vimrc
# sane screenrc
echo 'caption always
termcapinfo xterm*|rxvt*|kterm*|Eterm*|putty*|dtterm* ti@:te@
defscrollback 20736' > $HOME/.screenrc

### media libs
sudo dnf install -y gstreamer1-libav gstreamer1-plugins-ugly gstreamer1-plugins-bad-freeworld \
                    gstreamer1-plugins-bad-free HandBrake-cli

### spellcheck dictionaries
sudo dnf install -y hunspell-en hunspell-es hunspell-de hunspell-fr hunspell-nn

### LaTeX - quite large
sudo dnf install -y vim-latex vim-latex-doc texlive-collection-basic texlive-collection-fontsextra \
                    texlive-collection-fontsrecommended texlive-collection-langfrench \
                    texlive-collection-langgerman texlive-collection-langspanish \
                    texlive-collection-latexrecommended texlive-luatex texlive-xetex

### general apps
sudo dnf install -y calibre deja-dup epiphany firewalld geary gnome-contacts gnome-music \
                    gnome-weather gnumeric keepassx shotwell 

### GNOME tweaks
sudo dnf install -y gnome-shell-extension-alternate-tab gnome-tweak-tool
# set global gtk3 dark theme
mkdir -p $HOME/.config/gtk-3.0
echo '[Settings]
gtk-application-prefer-dark-theme=1' > $HOME/.config/gtk-3.0/settings.ini
# enable the alternate-tab extension we just installed
dconf write /org/gnome/shell/enabled-extensions "['alternate-tab@gnome-shell-extensions.gcampax.github.com']"  # alt-tab to switch windows not apps
# set Terminal dark theme. is this redundant? dark seems the default in 3.14?
dconf write /org/gnome/terminal/legacy/dark-theme true
# hide Terminal menu bar
dconf write /org/gnome/terminal/legacy/default-show-menubar false
# sane trackpad settings
dconf write /org/gnome/settings-daemon/peripherals/touchpad/natural-scroll true  # Mac-style scrolling
dconf write /org/gnome/settings-daemon/peripherals/touchpad/tap-to-click true

### firefox tweaks
## global settings
sudo dnf install -y mozilla-https-everywhere mozilla-noscript
# neuter the hazard of 'ctrl+q'
echo 'pref("browser.showQuitWarning", true);' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js >> /dev/null
# disable 'sponsored tiles'
echo 'pref("browser.newtabpage.directory.ping", "");' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js >> /dev/null
echo 'pref("browser.newtabpage.directory.source", "");' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js >> /dev/null
# set DONOTTRACK header
echo 'pref("privacy.donottrackheader.enabled", true);' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js >> /dev/null
# set spellcheck language as Canadian English moz#836230
echo 'pref("spellchecker.dictionary", "en_CA");' | sudo tee --append /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js >> /dev/null
## local settings
# create local profile
firefox -CreateProfile default >> /dev/null
# grab firefox profile name
FF=`grep Path .mozilla/firefox/profiles.ini | sed 's/Path\=//'`
# sane Firefox NoScript settings
echo 'user_pref("noscript.global", true);' | tee --append $HOME/.mozilla/firefox/${FF}/prefs.js >> /dev/null
echo 'user_pref("noscript.ctxMenu", false);' | tee --append $HOME/.mozilla/firefox/${FF}/prefs.js >> /dev/null
# set userContent.css workaround for moz#70315
mkdir -p $HOME/.mozilla/firefox/${FF}/chrome
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
/* input[type="radio"],
input[type="checkbox"] {
	border: 2px inset white ! important;
	background-color: white ! important;
	color: ThreeDFace ! important;
	-moz-appearance: none !important;
}
*|*::-moz-radio {
	background-color: white;
	-moz-appearance: none !important;
}
button,
input[type="reset"],
input[type="button"],
input[type="submit"] {
	border: 2px outset white;
	background-color: #eeeeee;
	color: black;
	-moz-appearance: none !important;
} */
body {
	background-color: white;
	color: black;
	display: block;
	margin: 8px;
	-moz-appearance: none !important;
}' > $HOME/.mozilla/${FF}/chrome/userContent.css

### set locale
## localectl is system-wide? dconf is local
# set language as Canadian English
localectl set-locale LANG=en_CA.UTF-8
dconf write /system/locale/region "'en_CA.UTF-8'"
# set keyboard as US-Macintosh mapping for sane internationalization
localectl set-x11-keymap us-mac mac
dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'us+mac')]"
# automatically adjust time zone per network geo-lookup
dconf write /org/gnome/desktop/datetime/automatic-timezone true

### games - quite large
sudo dnf install -y 0ad

### now reboot to save and load changes
reboot