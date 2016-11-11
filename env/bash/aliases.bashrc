# create handy aliases


# Set your paths
export ENV_PATH=$HOME/.env
export DEV_PATH=$HOME/workspace
export VIRTUALENV_PATH=$HOME/.virtualenv
export SVN_TOOL_PATH=$ENV_PATH/bin

# Create dynamic aliases
if [ -d ${DEV_PATH} ]; then
    for folder in $DEV_PATH/*; do
        alias cd-`basename $folder`="cd $folder"
    done
fi

if [ -d ${VIRTUALENV_PATH} ]; then
    FIND=/usr/bin/find
    INSTANCES=`${FIND} $VIRTUALENV_PATH -mindepth 1 -maxdepth 1 -type d`
    if [ ! -z "${INSTANCES}" ]; then
        for item in ${INSTANCES[@]}; do
            item=${item##*/}
            activate="${VIRTUALENV_PATH}/${item}/bin/activate"
            alias so-$item=". $activate"
            #alias 2${item}="cd ${DEV_PATH}/${item}; so-${item}"
        done
        unset item activate
    fi
    unset FIND INSTANCES
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
if [ `uname` = 'Linux' ]; then
    export PROFILE='~/.bashrc'

    alias ls='ls --color'
    alias grep='grep --color'
    alias du1='sudo du -h --max-depth 1'
else # Darwin
    export PROFILE='~/.bash_profile'

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
alias shrc="vim ${PROFILE}"
alias vimrc="vim ~/.vimrc"
alias py=python
alias py3=python3
alias ka9='killall -9'
alias k9='kill -9'
alias rm-rf='rm -rf'
alias gau='git add -u'
alias activate-venv='source venv/bin/activate'
alias so-venv='source venv/bin/activate'
alias sai='sudo apt-get install'
alias hig='history | grep'

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
