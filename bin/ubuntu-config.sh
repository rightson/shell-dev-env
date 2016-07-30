#!/bin/bash

APT_GET="sudo apt-get"
INSTALL="$APT_GET install -y"

essential() {
    $INSTALL git
    $INSTALL vim
    $INSTALL ctags 
    $INSTALL cscope
    $INSTALL tree
    $INSTALL openssh-server
    $INSTALL build-essential
    $INSTALL zsh
    $INSTALL tmux
    $INSTALL screen tmux
}

my_git() {
    git config --global user.email "rightson@gmail.com"
    git config --global user.name "Scott Chen"
}

kernel() {
    $APT_GET build-dep -y linux-image-$(uname -r)
}

desktop() {
    $INSTALL terminator
    $INSTALL ibus-chewing
    $INSTALL easystroke
}

desktop_more() {
    $INSTALL vim-gnome 
    $INSTALL openjdk-7-jre
    $INSTALL openjdk-8-jre
    $INSTALL xdotool terminator
    $INSTALL virt-viewer
    $INSTALL samba samba-common system-config-samba
    $INSTALL mongodb-server mongodb-clients
    $INSTALL filezilla
    add-apt-repository -y ppa:graphics-drivers/ppa
    $INSTALL nvidia-358
    apt-get -f install
}

vundle() {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

tpm() {
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

dev_common() {
    vundle
    tpm
    ohmyzsh
}

if [ -z $1 ]; then 
    echo "Usage: $0 essential|kernel|desktop|desktop_more|vundle|tpm|ohmyzsh|dev_common"
else
    $1
fi
