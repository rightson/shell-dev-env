# .bashrc


# Only source custom setting when in an interactive session
[ -z "$PS1" ] && return


PRE_INCLUDES=(
    /etc/bashrc
    /etc/bash.bashrc
    /etc/bash_completion
)
POST_INCLUDES=(
    ~/.my-env/prettfy-PS1.bashrc
    ~/.my-env/aliases.bashrc # alias must put at the end of source files
)

 
# Source environment settings 
for each in ${PRE_INCLUDES[@]}; do
    [ -r $each ] && . $each
done


# Create aliases for development dir

DEV_DIR=~/Developer
developer_shortcuts_creator() {
    for item in "$@"; do
        alias 2${item}="cd ${DEV_DIR}/${item};" 2> /dev/null
    done
}

DEVELOPER_DIRS=`ls ${DEV_DIR}`
developer_shortcuts_creator ${DEVELOPER_DIRS}


# For python virtualenv
VIRTUAL_ENV=~/Virtualenv
VIRTUALENV_INSTANCES=(`find $VIRTUAL_ENV -maxdepth 1 -mindepth 1 -type d | xargs basename`)
create_virtualenv_alias() {
    for item in "$@"; do
        alias so-$item=". ${VIRTUAL_ENV}/${item}/bin/activate"
    done
}
developer_shortcuts_venv_creator() {
    for item in "$@"; do
        alias 2${item}="cd ${DEV_DIR}/${item}; so-${item}"
    done
}

create_virtualenv_alias ${VIRTUALENV_INSTANCES[@]}
developer_shortcuts_venv_creator ${VIRTUALENV_INSTANCES[@]}


# Post include
for each in ${POST_INCLUDES[@]}; do
    [ -r $each ] && . $each
done


# Export global variables
export PATH=/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
#export PATH=/usr/local/share/python:$PATH
#export PATH=/usr/local/Cellar/ruby/1.9.3-p374/bin:$PATH
export VIM_BIN=/usr/bin/vim
export EDITOR=$VIM_BIN
export SVN_EDITOR=$EDITOR
export VISUAL=$VIM_BIN
export GREP_COLOR="1;33"
export HISTCONTROL=ignoreboth
export TERM=xterm

echo 'source ~/.my-env/setting.bashrc'
