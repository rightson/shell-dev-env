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

FILES=("$BASHRC|bashrc" "$VIMRC|vimrc" "$SCREENRC|screenrc")

function apply_patch() {

    echo 'Patching...'
    for each in ${FILES[@]}; do
        local rc_file=`echo $each | cut -d "|" -f 1`
        local rc_tmpl=`echo $each | cut -d "|" -f 2`
        if [ ! -f $rc_file ]; then
            echo "Creating $rc_file ... "
            touch $rc_file
        fi
        if [ -z "`grep \"$IDENTIFIER\" $rc_file`" ]; then
            echo "Patching $rc_tmpl: $rc_file ..."
            cat $RC_TEMPLATE_LOC/$rc_tmpl >> $rc_file
        fi
    done
    
    echo 'Done!'
    echo ''
    echo 'Please run below command to apply the change:'
    echo ''
    echo "  source $BASHRC"
    echo ''
}

case $1 in
    *)
        apply_patch
    ;;
esac
