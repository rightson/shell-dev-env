#!/bin/bash

function generate_dev_aliases() {
    if [ -d ${MY_DEV_ROOT} ]; then
        for folder in $MY_DEV_ROOT/*; do
            alias cd-`basename $folder`="cd $folder"
        done
    fi
}

function generate_venv_aliases() {
    if [ -d ${MY_VIRTUALENV_ROOT} ]; then
        FIND=/usr/bin/find
        INSTANCES=`${FIND} $MY_VIRTUALENV_ROOT -mindepth 1 -maxdepth 1 -type d`
        if [ ! -z "${INSTANCES}" ]; then
            for venv_name in ${INSTANCES[@]}; do
                venv_name=${venv_name##*/}
                activate="${MY_VIRTUALENV_ROOT}/${venv_name}/bin/activate"
                alias so-$venv_name=". $activate"
            done
            unset venv_name activate
        fi
        unset FIND INSTANCES
    fi
}

function set_title() {
    ORIG=$PS1
    TITLE="\e]2;$*\a"
    PS1=${ORIG}${TITLE}
}
