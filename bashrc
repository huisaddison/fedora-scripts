# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=


# User specific aliases and functions
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi

# Aliases that make my life easier
alias gogo='gnome-open'
alias python='python3'

# Custom clip function that pastes from a file to clipboard
# very useful because vim cannot access the system clipboard
customclip() {
    if [ "$#" -eq 1 ]; then
        cat $1 | sed -n 'p' | xclip -selection clipboard
    elif [ "$#" -eq 2 ]; then
        cat $1 | sed -n "$2 p" | xclip -selection clipboard
    elif [ "$#" -eq 3 ]; then
        cat $1 | sed -n "$2, $3 p" | xclip -selection clipboard
    fi
}
alias cclip=customclip 
