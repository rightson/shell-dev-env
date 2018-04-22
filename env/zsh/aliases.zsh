#!/bin/zsh
# create handy aliases


# Set your paths
export ENV_PATH=$HOME/.env
export DEV_PATH=$HOME/workspace
export VIRTUALENV_PATH=$HOME/.virtualenv
export SVN_TOOL_PATH=$ENV_PATH/bin

# Create dynamic aliases in $DEV_PATH
if [ -d ${DEV_PATH} ]; then
    for folder in $DEV_PATH/*; do
        alias cd-`basename $folder`="cd $folder"
    done
fi

# Create dynamic aliases in $VIRTUALENV_PATH
if [ -d ${VIRTUALENV_PATH} ]; then
    for env in $VIRTUALENV_PATH/*; do
        activate="$env/bin/activate"
        name=`basename $env`
        if [ -n $name ]; then
            alias so-virtualenv-$name=". $activate"
        fi
    done
fi


# Shortcuts for svn cmd line
if [ -d ${SVN_TOOL_PATH} ]; then
    alias svndiff="svn di --diff-cmd ${SVN_TOOL_PATH}/svn-diff.sh"
    alias s=".  ${SVN_TOOL_PATH}/list-svn-diff.sh set"
    alias sc=". ${SVN_TOOL_PATH}/list-svn-diff.sh set check"
    alias sr=". ${SVN_TOOL_PATH}/list-svn-diff.sh reset"
fi
alias st='svn status'
alias stq='svn status -q'
alias svnup="find . -type d | grep -v .svn | xargs svn up"



# Platform dependent arguments
if [[ `uname` = 'Linux' ]]; then
    export PROFILE='~/.zshrc'

    alias ls='ls --color'
    alias grep='grep --color'
    alias du1='sudo du -h --max-depth 1'
else # Darwin
    export PROFILE='~/.zshrc'

    alias ls='ls -G'
    alias grep='grep --color'
    alias du1='sudo du -h -d1'
    alias toggle-hidden-file='defaults write com.apple.Finder AppleShowAllFiles'
fi


# Command with default arguments
alias mv='mv -i'
alias scp='scp -r'
alias wget='wget -c'
alias tree='tree -C'


# Shortcut commands
alias l='ls -lCF'
alias l.='ls -ld .*'
alias la='ls -A'
alias ll='ls -l'
alias lh='ls -lh'
alias lj='ls -lh ~/jobs'
alias al='alias'
alias hi='history'
alias steal='sudo chown -R `id -u`:`id -g`'
alias 755='sudo chmod -R 755'
alias py=python
alias simple-http="echo $SIMPLE_HTTP; $SIMPLE_HTTP"
alias ka='while [ 1 ]; do echo -ne "\rKeeping Connection Alive (`date`)" ; sleep 10; done'
alias so=". ${PROFILE}"
alias env-reload="$ENV_PATH/deploy.sh all"
alias shrc="vim ${PROFILE}"
alias vimrc="vim ~/.vimrc"
alias gvimrc="gvim ~/.gvimrc"
alias tmuxrc="vim ~/.tmux.conf"
alias py=python
alias py3=python3
alias ka9='killall -9'
alias k9='kill -9'
alias rm-rf='rm -rf'
alias gau='git add -u'
alias activate-venv='source venv/bin/activate'
alias so-venv='source venv/bin/activate'
alias mk-venv='python3 -m venv venv; venv/bin/pip install --upgrade pip'
alias sai='sudo apt-get install'
alias hig='history | grep'
alias known_host='vim ~/.ssh/known_hosts'
alias t='tmux'
alias tl='tmux ls'
alias tn='tmux new -s'
alias ta='tmux attach'
alias tat='tmux attach -t'
alias clr='rm -f cscope.* ncscope.* tags'
alias sus='sudo ufw status'
alias ai='sudo apt install'

grep2() {
    grep $1 | grep -v grep | grep --color $1
}

gopath() {
    if [ ! -z $1 ]; then
        export GOPATH=`cd $1 && pwd`
        export PATH=$GOPATH/bin:$PATH
    fi
    echo $GOPATH
}

# Unset variables
unset SIMPLE_HTTP
unset ENV_PATH SVN_TOOL_PATH DEV_PATH
