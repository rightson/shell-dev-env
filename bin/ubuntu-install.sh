# install script for ubuntu 14.04 LTS
apt-get update
apt-get upgrade
apt-get install -y vim vim-gnome ctags cscope
apt-get install -y openssh-server
apt-get install -y git
apt-get install -y zsh
apt-get install -y build-essential
apt-get install -y screen tmux
apt-get install -y ibus-chewing
apt-get install -y openjdk-7-jre
apt-get install -y openjdk-8-jre
apt-get install -y easystroke
apt-get install -y xdotool terminator
apt-get install -y virt-viewer
apt-get install -y samba samba-common system-config-samba
apt-get install -y mongodb-server  mongodb-clients
apt-get install -y filezilla
#apt-get source linux-image-$(uname -r)
add-apt-repository -y ppa:graphics-drivers/ppa
apt-get update -y
apt-get install -y nvidia-358
apt-get -f install
