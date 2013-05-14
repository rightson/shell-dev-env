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

RC_FILES=("$BASHRC|bashrc" "$VIMRC|vimrc" "$SCREENRC|screenrc")
ENV_FILES=$SCRIPT_LOCATION/env/bash/*.bashrc

apply_patch() {

    echo "Patching at $SCRIPT_LOCATION..."
    local script_loc=$(echo $SCRIPT_LOCATION | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/*/\\\&/g')
    for each in ${RC_FILES[@]}; do
        local rc_file=`echo $each | cut -d "|" -f 1`
        local rc_tmpl=`echo $each | cut -d "|" -f 2`
        if [ ! -f $rc_file ]; then
            echo "Creating $rc_file ... "
            touch $rc_file
        fi
        if [ -z "`grep \"$IDENTIFIER\" $rc_file`" ]; then
            echo "Patching $rc_tmpl: $rc_file ..."
	        cat $RC_TEMPLATE_LOC/$rc_tmpl | \
            sed "s/S_LOC/$(echo $script_loc)/g" >> $rc_file
        fi
        local softlink=$SCRIPT_LOCATION/$rc_tmpl
        if [ ! -f $softlink ]; then
            echo "Creating softlink for $rc_file at $softlink"
            ln -s $rc_file $softlink
        fi
    done

    # Patch bashrc
    sed "s/export ENV_PATH=.*$/export ENV_PATH=$(echo $script_loc)\/bin/g" -i $ENV_FILES
    
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
