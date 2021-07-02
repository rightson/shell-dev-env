#!/bin/zsh

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


root="%{$fg[red]%}$username%{$reset_color%}"
user="%{$fg[red]%}$username%{$reset_color%}"
user_at_host="%{$fg_bold[green]%}%n@%m"
host="%{$fg[yellow]%}$hostname%{$reset_color%}"
rpwd="%{$fg[green]%}%/%{$reset_color%}"
opwd="%{$fg[green]%}$cwd%{$reset_color%}"
get_cwd="%{$fg[blue]%}[%~]%{$reset_color%}"
get_now="%{$fg[purple]%}%D{[%X]}%{$reset_color%}"
datetime="%{$fg[magenta]%}[%* %D{%Y/%m/%d}]%{$reset_color%}"
at="%{$fg[white]%}@%{$reset_color%}"
sh_in_use="%{$fg[blue]%}(`ps -p$$ | tail -1 | awk '{print $NF}' | tr -cd '[:alnum:]/' | xargs basename`)%{$reset_color%}"
#sh_in_use=`echo $0 | sed 's/-//'`

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git cvs svn
zstyle ':vcs_info:git*' formats " (%b)"
vcs_info_wrapper() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo "%{$fg[cyan]%}${vcs_info_msg_0_}%{$reset_color%}$del"
    else
        echo "%{$fg[black]%}%{$reset_color%}"
    fi
}

PROMPT_L2=$'\n'"%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} "
PROMPT='${user}${at}${host}:${opwd}$(vcs_info_wrapper) ${datetime} ${sh_in_use} ${PROMPT_L2}'
