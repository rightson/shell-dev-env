#!/bin/bash

IDENTIFIER='Added by shell-dev-env.'
SCRIPT_LOCATION=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
RC_TEMPLATE_LOC=$SCRIPT_LOCATION/rc

BASHRC=$HOME/.bash_profile
if [ "`uname`" = "Linux" ]; then
    BASHRC=$HOME/.bashrc
fi
VIMRC=$HOME/.vimrc
SCREENRC=$HOME/.screenrc

FILES=($BASHRC $VIMRC $SCREENRC)

function apply_patch() {

    echo 'Patching...'
    for each in ${FILES[@]}; do
        if [ ! -f $each ]; then
            echo "Creating rc file $each"
            touch $each
        fi
    done
    
    if [ -z "`grep \"$IDENTIFIER\" $BASHRC`" ]; then
        echo "Patching bashrc: $BASHRC"
        cat $RC_TEMPLATE_LOC/bashrc >> $BASHRC
    fi
    
    if [ -z "`grep \"$IDENTIFIER\" $VIMRC`" ]; then
        echo "Patching vimrc: $BASHRC"
        cat $RC_TEMPLATE_LOC/vimrc >> $VIMRC
    fi
    
    if [ -z "`grep \"$IDENTIFIER\" $SCREENRC`" ]; then
        echo "Patching screenrc: $BASHRC"
        cat $RC_TEMPLATE_LOC/screenrc >> $SCREENRC
    fi
    
    echo 'Done!'
}

case $ARGV[1] in
    *)
        apply_patch
    ;;
esac
