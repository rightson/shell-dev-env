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
            ip=`/sbin/ifconfig | grep -A1 -e "^$interface" | tail -n 1 | awk '{print $2}' | sed 's/addr://g'`
        else
            interface="en${i}"
            ip=`/sbin/ifconfig | grep -A3 -e "^$interface" | tail -n 1 | awk '{print $2}'` 
        fi
        echo $ip
        return
    done
    echo 'localhost'
}

username=%n
#hostname=%m
hostname=`get_ipaddr`
cwd=%~

root="%{$fg[red]%}$username%{$reset_color%}"
user="%{$fg[red]%}$username%{$reset_color%}"
host="%{$fg[blue]%}$hostname%{$reset_color%}"
rpwd="%{$fg[yellow]%}%/%{$reset_color%}"
opwd="%{$fg[yellow]%}$cwd%{$reset_color%}"
date="%{$fg[green]%}%*%{$reset_color%}"
at="@"

ps1_root() {
    PS1="${root}@${host}[\w]# "
}

ps1_pretty() {
    RPROMPT="[${date}]"
    PROMPT="${user}${at}${host}:${rpwd}"$'\n'"➜  "
    #PS1="${user}${at}${host}:${rpwd}[${date}]"$'\n'"➜  "
    #PS1="${user}${at}${host}:${rpwd}"$'\n'"[${date}] ➜  "
}

ps1_relative() {
    PS1="[$opwd]$ "
}

ps1_absolute() {
    PS1="[$rpwd]$ "
}

function term_title() {
    echo -e "\033];$USER - `basename $PWD`\007"
}

autoload -U add-zsh-hook
add-zsh-hook precmd term_title

if [ "`id -u`" -eq 0 ]; then
    ps1_root
else
    ps1_pretty
fi 

