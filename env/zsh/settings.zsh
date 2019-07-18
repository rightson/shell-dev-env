# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit
# End of lines added by compinstall

zstyle ':completion*' completer _complete _ignored _files
#zstyle ':completion*' completer _files

vimode() {
    bindkey -v
    bindkey '^P' up-history
    bindkey '^N' down-history
    bindkey '^A' vi-beginning-of-line
    bindkey '^E' vi-end-of-line
    bindkey '^U' kill-whole-line

    bindkey '^p' up-history
    bindkey '^n' down-history
    bindkey '^a' vi-beginning-of-line
    bindkey '^e' vi-end-of-line
    bindkey '^u' kill-whole-line
}
vimode

export MY_GW_IP=$HOME/.cache/my-gw-ip

function rs () {
    local ip=
    vared -p "Enter desired gateway IP => " ip
    echo $ip > $MY_GW_IP
}
function ra () {
    local gwip=`cat $MY_GW_IP`
    local exists=`route -n | head -n 3 | grep $gwip`
    if [ -z "$exists" ]; then
        local cmd="sudo route add -net default gw $gwip metric 1"
        echo $cmd; eval $cmd;
    fi
    route -n | grep $gwip
}
function rc () {
    local gwip=`cat $MY_GW_IP`
    local cmd='sudo route del -net default gw $gwip metric 1'
    echo $cmd; eval $cmd;
    route -n
}

export ENV_PATH=$HOME/.env
export PATH=$HOME/local/bin:$ENV_PATH/bin:/usr/local/sbin:/usr/local/bin:$PATH
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=cyan
export LC_ALL=${LANG}
