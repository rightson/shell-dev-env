# Aliases

# common aliases
alias al='alias'
alias aliasrc="vim $ENV_ROOT/inc/aliases.sh"

# add common parameter
alias mv='mv -i'
alias cp='cp -r'
alias scp='scp -r'
alias wget='wget -c'
alias tree='tree -C'
if [[ `uname` = 'Linux' ]]; then
    alias ls='ls --color'
    alias grep='grep --color'
    alias du1='sudo du -h --max-depth 1'
else # Darwin
    alias ls='ls -G'
    alias grep='grep --color'
    alias du1='sudo du -h -d1'
    alias toggle-hidden-file='defaults write com.apple.Finder AppleShowAllFiles'
fi

# ls aliases
alias l='ls -lCF'
alias l.='ls -ld .*'
alias la='ls -A'
alias ll='ls -l'
alias lh='ls -lh'

# history aliases
alias hi='history'
alias hig='history | grep'

# chown/chmod
alias steal='sudo chown -R `id -u`:`id -g`'
alias 755='sudo chmod -R 755'

# kill aliases
alias ka9='killall -9'
alias k9='kill -9'

# rm aliases
alias rm-rf='rm -rf'
alias rm-tags='rm -f cscope.* ncscope.* tags'

# rc aliases
alias so=". ${PROFILE}"
alias shrc="vim ${PROFILE}"
alias vimrc="vim ~/.vimrc"
alias gvimrc="gvim ~/.gvimrc"
alias tmuxrc="vim ~/.tmux.conf"

alias public-ip='curl ipinfo.io/ip'

# python aliases
alias py=python
alias py3=python3

# venv aliasees
# alias so-venv='source venv/bin/activate'
# alias mk-venv='python3 -m venv venv; venv/bin/pip install --upgrade pip'

# tmux aliases
alias t='tmux'
alias tl='tmux ls'
alias tn='tmux new -s'
alias ta='tmux attach'
alias tat='tmux attach -t'

# apt aliases
alias sau='sudo apt update'
alias sai='sudo apt install'
alias sas='sudo apt search'
alias saug='sudo apt upgrade'
alias sadu='sudo apt dist-upgrade'
alias sarm='sudo apt autoremove'

# alias ufw
alias sus='sudo ufw status'
alias sen='sudo ufw enable'
alias srm='sudo ufw remove'

alias vbm='VBoxManage'

grep2() {
    grep $1 | grep -v grep | grep --color $1
}

alias xopen='xdg-open'
