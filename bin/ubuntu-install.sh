#!/bin/bash

essential() {
    apt-get install -y git
    apt-get install -y vim
    apt-get install -y ctags 
    apt-get install -y cscope
    apt-get install -y tree
    apt-get install -y openssh-server
    apt-get install -y build-essential
    apt-get install -y zsh
    apt-get install -y tmux
    apt-get install -y screen tmux
}

my_git() {
    git config --global user.email "rightson@gmail.com"
    git config --global user.name "Scott Chen"
}

kernel() {
    apt-get build-dep linux-image-$(uname -r)
}

desktop() {
    apt-get install -y terminator
    apt-get install -y ibus-chewing
    apt-get install -y easystroke
}

desktop_more() {
    apt-get install -y vim-gnome 
    apt-get install -y openjdk-7-jre
    apt-get install -y openjdk-8-jre
    apt-get install -y xdotool terminator
    apt-get install -y virt-viewer
    apt-get install -y samba samba-common system-config-samba
    apt-get install -y mongodb-server mongodb-clients
    apt-get install -y filezilla
    add-apt-repository -y ppa:graphics-drivers/ppa
    apt-get install -y nvidia-358
    apt-get -f install
}


if [ -z $1 ]; then 
    echo "Usage: $0 essential|kernel|desktop|desktop_more"
else
    apt-get update
    $1
fi

