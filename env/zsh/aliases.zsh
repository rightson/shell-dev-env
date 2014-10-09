#!/bin/zsh
# create handy aliases


# Set your paths
export ENV_PATH=/Users/rightson/.env
export DEV_PATH=~/development
export VIRTUALENV_PATH=~/.virtualenv
export SVN_TOOL_PATH=$ENV_PATH/bin

# Cmds
export SIMPLE_HTTP='python -m SimpleHTTPServer 8000'


# Create dynamic aliases
if [ -d ${DEV_PATH} ]; then
    LS=/bin/ls
    PROJECTS=`${LS} ${DEV_PATH}`
    for item in ${PROJECTS[@]}; do
        dest=${DEV_PATH}/${item}
        if [ ! -z "${item}" ]; then
            if [ "${item:0:1}" = "L" ]; then
                build=pkg-odm_adps_full_features-20110916/ast2300_evb_build
                apps=$build/apps
                ipmi=$apps/ipmi
                tm5=$ipmi/platform/evb
                dir1="${dest}/SourceCode/"
                dir2="${dest}/"
                dev_dir=
                if [ -d "${dir1}" ]; then
                    dev_dir=$dir1
                elif [ -d "${dir2}" ]; then
                    dev_dir=$dir2
                fi
                alias 2${item}-="cd $dev_dir"
                alias 2${item}-build="cd $dev_dir/$build"
                alias 2${item}-apps="cd $dev_dir/$apps"
                alias 2${item}-ipmi="cd $dev_dir/$ipmi"
                alias 2${item}-tm5="cd $dev_dir/$tm5"
            else
                alias 2${item}="cd ${dest}"
            fi
        fi
    done
    unset LS PROJECTS
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

alias go-test-server='ssh mtk06137@172.22.72.64'

# Unset variables
unset SIMPLE_HTTP
unset ENV_PATH SVN_TOOL_PATH DEV_PATH
