#!/bin/bash

if [ -z "$MY_DEV_ROOT" ]; then
    export MY_DEV_ROOT=$HOME/workspace
fi
if [ -z "$MY_VIRTUALENV_ROOT" ]; then
    export MY_VIRTUALENV_ROOT=$HOME/.virtualenvs
fi

if [[ `uname` = 'Linux' ]]; then
    export PROFILE='~/.bashrc'
else # Darwin
    export PROFILE='~/.bash_profile'
fi

# Create dynamic aliases
if [ -d ${MY_DEV_ROOT} ]; then
    for folder in $MY_DEV_ROOT/*; do
        alias cd-`basename $folder`="cd $folder"
    done
fi

if [ -d ${MY_VIRTUALENV_ROOT} ]; then
    FIND=/usr/bin/find
    INSTANCES=`${FIND} $MY_VIRTUALENV_ROOT -mindepth 1 -maxdepth 1 -type d`
    if [ ! -z "${INSTANCES}" ]; then
        for item in ${INSTANCES[@]}; do
            item=${item##*/}
            activate="${MY_VIRTUALENV_ROOT}/${item}/bin/activate"
            alias so-$item=". $activate"
            #alias 2${item}="cd ${MY_DEV_ROOT}/${item}; so-${item}"
        done
        unset item activate
    fi
    unset FIND INSTANCES
fi

