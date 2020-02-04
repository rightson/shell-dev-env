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
            ip=`ip addr show dynamic | grep inet | head -n 1 | awk '{print $2}' | sed 's/\/[0-9]*//g'`
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
hostname=%m
#hostname=`get_ipaddr`
cwd=%~

autoload -Uz vcs_info
precmd() { vcs_info }

root="%{$fg[red]%}$username%{$reset_color%}"
user="%{$fg[red]%}$username%{$reset_color%}"
user_at_host="%{$fg_bold[green]%}%n@%m"
host="%{$fg[yellow]%}$hostname%{$reset_color%}"
rpwd="%{$fg[green]%}%/%{$reset_color%}"
opwd="%{$fg[green]%}$cwd%{$reset_color%}"
get_cwd="%{$fg[blue]%}[%~]%{$reset_color%}"
get_now="%{$fg[purple]%}%D{[%X]}%{$reset_color%}"
date="%{$fg[red]%}%D{%Y/%m/%d}%{$reset_color%}"
datetime="%{$fg[magenta]%}[%* %D{%Y/%m/%d}]%{$reset_color%}"
at="%{$fg[white]%}@%{$reset_color%}"

prompt2=$'\n'"%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} "
#gitbranch=$(git rev-parse --abbrev-ref HEAD)
#gb="%{$fg[red]%}$gitbranch%{$reset_color%}"

ps1_root() {
    PS1="${root}${at}${host}[${cwd}]# "
}

ps1_pretty() {
    PROMPT="${user}${at}${host}:${opwd} ${datetime}${prompt2}"
    #PROMPT="${user}${at}${host}:${rpwd}"$'\n'"➜  "
    #RPROMPT="${date}"
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

#autoload -U add-zsh-hook
#add-zsh-hook precmd term_title

if [ "`id -u`" -eq 0 ]; then
    ps1_root
else
    ps1_pretty
fi

