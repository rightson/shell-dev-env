#!/bin/bash
# aliases


# Paths
export ENV_PATH=~/.my-env
export BIN_PATH=/usr/local/bin
export DEV_PATH=~/Developer
export VIRTUALENV_PATH=~/Virtualenv

# Cmds
export SIMPLE_HTTP='python -m SimpleHTTPServer 8000'

# Platform dependent arguments
if [ `uname` == 'Linux' ]; then
    export BASH_RCFILE='~/.bashrc'

    alias ls='ls --color'
    alias grep='grep -rn --color'
    alias du1='sudo du -h --max-depth 1'
else # Darwin
    export BASH_RCFILE='~/.bash_profile'

    alias ls='ls -G'
    alias grep='grep --color'
    alias du1='sudo du -h -d1'
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
alias so="unalias -a ; . ${BASH_RCFILE}"
alias virc="vim ${ENV_PATH}"
alias kill-vnc='vncserver -kill'
alias kill-ssh='killall -9 ssh'
alias clean-swp='rm -f .*.swp'


# Shortcuts for svn cmd line
if [ -d ${BIN_PATH} ]; then
    alias svndiff="svn di --diff-cmd ${BIN_PATH}/svndiff.sh"
    alias s=".  ${BIN_PATH}/list_svn_diff.sh set"
    alias sc=". ${BIN_PATH}/list_svn_diff.sh set check"
    alias sr=". ${BIN_PATH}/list_svn_diff.sh reset"
fi
alias st='svn status'
alias stq='svn status -q'
alias svnup="find . -type d | grep -v .svn | xargs svn up"


# Shortcuts for remote access
alias reverse-ln='ssh -D 8888 -N -f rightson@rightson.org'
alias 2is='ssh is90246@alumni.cis.nctu.edu.tw'
alias 2dorm7='ssh rightson@dorm7.com'
alias 2ln='ssh rightson@rightson.org'
alias 2build-machine='ssh scott@10.32.48.162'


# Create dynamic alias
if [ -d ${DEV_PATH} ]; then
    for item in `ls ${DEV_PATH}`; do
        alias 2${item}="cd ${DEV_DIR}/${item};" 2> /dev/null
    done
fi


if [ -d ${VIRTUALENV_PATH} ]; then
    INSTANCES=`find $VIRTUALENV_PATH -mindepth 1 -maxdepth 1 -type d`
    if [ ! -z "${INSTANCES}" ]; then
        for item in ${INSTANCES[@]}; do
            item=${item##*/}
            activate="${VIRTUALENV_PATH}/${item}/bin/activate"
            alias so-$item=". $activate"
            #alias 2${item}="cd ${DEV_PATH}/${item}; so-${item}"
        done
    fi
fi


# Unset variables
unset SIMPLE_HTTP
unset ENV_PATH BIN_PATH DEV_PATH
