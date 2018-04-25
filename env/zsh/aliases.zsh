#!/bin/zsh

# Set your paths
export ENV_PATH=$HOME/.env
export DEV_PATH=$HOME/workspace
export VIRTUALENV_PATH=$HOME/.virtualenv
if [[ `uname` = 'Linux' ]]; then
    export PROFILE='~/.zshrc'
else # Darwin
    export PROFILE='~/.zshrc'
fi

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

source $ENV_PATH/env/aliases.sh

# Unset variables
unset ENV_PATH DEV_PATH
