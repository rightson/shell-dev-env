#!/bin/zsh
# prettfy PS1 in bash

autoload -U colors && colors

get_ipaddr()
{
    local interface=
    local ip=
    for i in `seq 0 1 10`; do
        if [ `uname` = 'Linux' ]; then
            interface="eth${i}"
            ip=`/sbin/ifconfig | grep -A1 -e "^$interface" | tail -n 1` 
        else
            interface="en${i}"
            ip=`/sbin/ifconfig | grep -A3 -e "^$interface" | tail -n 1 | awk '{print $2}'` 
        fi
        if [[ $ip =~ ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) ]]; then 
            echo ${BASH_REMATCH[1]};
            return
        fi
    done
    echo 'localhost'
}

username=%n
hostname=%m
cwd=%~

root="%{$fg[red]%}$username%{$reset_color%}"
user="%{$fg[red]%}$username%{$reset_color%}"
host="%{$fg[blue]%}$hostname%{$reset_color%}"
rpwd="%{$fg[yellow]%}%/%{$reset_color%}"
opwd="%{$fg[yellow]%}$cwd%{$reset_color%}"
date="%{$fg[green]%}%t%{$reset_color%}"
at="@"

ps1_root() {
    PS1="${root}@${host}[\w]# "
}

ps1_pretty() {
    PS1="${user}${at}${host}:${rpwd}[${date}]"$'\n'"➜ "
}

ps1_relative() {
    PS1="[$opwd]$ "
}

ps1_absolute() {
    PS1="[$rpwd]$ "
}

if [ "`id -u`" -eq 0 ]; then
    ps1_root
else
    ps1_pretty
fi 

