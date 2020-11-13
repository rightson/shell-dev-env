#!/bin/zsh

export MY_DEV_PATH=$HOME/workspace
export MY_VIRTUALENV_PATH=$HOME/.virtualenv

if [[ `uname` = 'Linux' ]]; then
    export PROFILE='~/.zshrc'
else # Darwin
    export PROFILE='~/.zshrc'
fi

# Create dynamic aliases in $MY_DEV_PATH
if [ -d ${MY_DEV_PATH} ]; then
    for folder in $MY_DEV_PATH/*; do
        alias cd-`basename $folder`="cd $folder"
    done
fi

# Create dynamic aliases in $MY_VIRTUALENV_PATH
if [ -d ${MY_VIRTUALENV_PATH} ]; then
    for env in $MY_VIRTUALENV_PATH/*; do
        activate="$env/bin/activate"
        name=`basename $env`
        if [ -n $name ]; then
            alias so-virtualenv-$name=". $activate"
        fi
    done
fi

