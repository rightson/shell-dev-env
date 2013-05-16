#!/bin/bash

SCRIPT_LOCATION=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
SCRIPT_LOC_ESCAPED=$(echo $SCRIPT_LOCATION | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/*/\\\&/g')

RC_TEMPLATE_LOC=$SCRIPT_LOCATION/rc
BASHRC=$HOME/.bash_profile
if [ "`uname`" = "Linux" ]; then
    BASHRC=$HOME/.bashrc
fi
VIMRC=$HOME/.vimrc
SCREENRC=$HOME/.screenrc

IDENTIFIER='Added by shell-dev-env.'

patch_rc() {
    local RC_FILES=("$BASHRC|bashrc" "$VIMRC|vimrc" "$SCREENRC|screenrc")
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
            sed "s/S_LOC/$(echo $SCRIPT_LOC_ESCAPED)/g" >> $rc_file
        fi
        local softlink=$SCRIPT_LOCATION/$rc_tmpl
        if [ ! -f $softlink ]; then
            echo "Creating softlink for $rc_file at $softlink"
            ln -s $rc_file $softlink
        fi
    done

}

patch_bash() {
    local ENV_FILES=$SCRIPT_LOCATION/env/bash/*.bashrc
    sed "s/export ENV_PATH=.*$/export ENV_PATH=$(echo $SCRIPT_LOC_ESCAPED)/g" -i $ENV_FILES
    
    echo ''
    echo 'Please run below command to apply the change:'
    echo ''
    echo "  source $BASHRC"
    echo ''
    echo 'After that, use "virc" or "so" to edit or apply rc files'
    echo ''
}

apply_patch() {
    echo "Patching at $SCRIPT_LOCATION..."
    patch_rc 
    patch_bash
    echo 'Done!'
}

case $1 in
    rc)
        patch_rc
        ;;
    bash)
        patch_bash
        ;;
    *)
        apply_patch
        ;;
esac

