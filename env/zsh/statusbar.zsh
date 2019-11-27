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
#hostname=%m
hostname=`get_ipaddr`
cwd=%~

root="%{$fg[red]%}$username%{$reset_color%}"
user="%{$fg[green]%}$username%{$reset_color%}"

user_at_host="%{$fg_bold[green]%}%n@%m"

host="%{$fg[green]%}$hostname%{$reset_color%}"
rpwd="%{$fg[yellow]%}%/%{$reset_color%}"
opwd="%{$fg[yellow]%}$cwd%{$reset_color%}"

get_cwd="%{$fg[white]%}[%~]%{$reset_color%}"

get_now="%{$fg[blue]%}%D{[%X]}%{$reset_color%}"

date="%{$fg[red]%}<%D>%{$reset_color%}"
time="%{$fg[cyan]%}%*%{$reset_color%}"
at="@"

get_prompt=$'\n'"%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} "

#gitbranch=$(git rev-parse --abbrev-ref HEAD)
#gb="%{$fg[red]%}$gitbranch%{$reset_color%}"

ps1_root() {
    PS1="${root}@${host}[${cwd}]# "
}

ps1_pretty() {
    #PROMPT="${user_at_host} ${get_now} ${get_cwd} $(git_prompt_info) ${date} ${get_prompt}"
    RPROMPT="${date}"
    #PROMPT="${user}${at}${host}:${rpwd}"$'\n'"# "
    #PROMPT="${user}${at}${host}:${opwd}"$'\n'"# "
    #PROMPT="${user}${at}${host}:${rpwd}"$'\n'"➜  "
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

#autoload -U add-zsh-hook
#add-zsh-hook precmd term_title

if [ "`id -u`" -eq 0 ]; then
    ps1_root
else
    ps1_pretty
fi

