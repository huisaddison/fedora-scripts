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
alias lion='ssh ah729@lion.zoo.cs.yale.edu'
alias supersubmit='ssh ah729@lion.zoo.cs.yale.edu "sh autosubmit.sh"'
alias green='ssh addison@green.student.yale.internal'
alias lb='ls -B'
alias hours='python /c/cs223/autocount.py'
alias autolog='python /c/cs223/autotrack.py'
alias aaron='ssh -X addison@40.117.239.180'
alias jpydock='ssh -NL 8888:localhost:9998 addison@40.117.239.180'

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

scc() {
    if dconf read /org/gnome/desktop/input-sources/xkb-options \
                    | grep -q "swapcaps"; then
        dconf write /org/gnome/desktop/input-sources/xkb-options "@as []"
    else 
        dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:swapcaps']"
    fi
}

aws() {
    ssh -i /home/addison/aws_keypairs/kp1.pem ubuntu@$1
}

PATH=$PATH:/usr/local/share/scala/bin
PATH=$PATH:/usr/local/share/idea/bin
