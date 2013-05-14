#!/bin/bash

IDENTIFIER='Added by shell-dev-env.'
SCRIPT_LOCATION=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
LOC_FILE=$SCRIPT_LOCATION/script-location
BASE_NAME=`echo $SCRIPT_LOCATION | tee $LOC_FILE`
RC_TEMPLATE_LOC=$SCRIPT_LOCATION/rc

BASHRC=$HOME/.bash_profile
if [ "`uname`" = "Linux" ]; then
    BASHRC=$HOME/.bashrc
fi
VIMRC=$HOME/.vimrc
SCREENRC=$HOME/.screenrc

FILES=("$BASHRC|bashrc" "$VIMRC|vimrc" "$SCREENRC|screenrc")

function apply_patch() {

    echo "Patching at $SCRIPT_LOCATION..."
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
            #str=`echo "$SCRIPT_LOCATION" | perl -pe perl -pe 's/\\/\\\\/g'`
            #cat $RC_TEMPLATE_LOC/$rc_tmpl | sed "s/S_LOC/$str/g" >> $rc_file
        fi
        local softlink=$SCRIPT_LOCATION/$rc_tmpl
        if [ ! -f $softlink ]; then
            echo "Creating softlink for $rc_file at $softlink"
            ln -s $rc_file $softlink
        fi
    done
    
    echo 'Done!'
    echo ''
    echo 'Please run below command to apply the change:'
    echo ''
    echo "  source $BASHRC"
    echo ''
    echo 'After that, use "virc" or "so" to edit or apply rc files'
}

case $1 in
    *)
        apply_patch
    ;;
esac
