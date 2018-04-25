#!/bin/bash

# Set your paths
export __DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ENV_PATH=$HOME/.env
export DEV_PATH=$HOME/workspace
export VIRTUALENV_PATH=$HOME/.virtualenv
if [[ `uname` = 'Linux' ]]; then
    export PROFILE='~/.bashrc'
else # Darwin
    export PROFILE='~/.bash_profile'
fi

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

source $ENV_PATH/env/aliases.sh

# Unset variables
unset ENV_PATH DEV_PATH
