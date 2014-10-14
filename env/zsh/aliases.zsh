#!/bin/zsh
# create handy aliases


# Set your paths
export ENV_PATH=/Users/rightson/.env
export DEV_PATH=~/development
export VIRTUALENV_PATH=~/.virtualenv
export SVN_TOOL_PATH=$ENV_PATH/bin

# Cmds
export SIMPLE_HTTP='python -m SimpleHTTPServer 8000'


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
        alias so-virtualenv-$item=". $activate"
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
alias steal='sudo chown -R `id -u`:`id -g`'
alias 755='sudo chmod -R 755'
alias py=python
alias simple-http="echo $SIMPLE_HTTP; $SIMPLE_HTTP"
alias ka='while [ 1 ]; do echo -ne "\rKeeping Connection Alive (`date`)" ; sleep 10; done'
alias so=". ${PROFILE}"
alias virc="vim ${ENV_PATH}/env"
alias rm-swp='rm -f .*.swp'

alias ainstall='sudo apt-get install -y'
alias asearch='sudo apt-cache search'
alias yinstall='sudo yum install -y'

grep2() {
    grep $1 | grep -v grep | grep --color $1
}

# Unset variables
unset SIMPLE_HTTP
unset ENV_PATH SVN_TOOL_PATH DEV_PATH
