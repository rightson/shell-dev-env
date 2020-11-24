#!/bin/zsh

function generate_dev_aliases() {
    if [ -d ${MY_DEV_ROOT} ]; then
        for folder in $<MY_DEV_ROOT>/*; do
            alias cd-`basename $folder`="cd $folder"
        done
    fi
}

function generate_venv_aliases() {
    if [ -d ${MY_VIRTUALENV_ROOT} ]; then
        for env in $MY_VIRTUALENV_ROOT/*; do
            activate="$env/bin/activate"
            venv_name=`basevenv_name $env`
            if [ -n $venv_name ]; then
                alias so-virtualenv-$venv_name=". $activate"
            fi
        done
    fi
}
