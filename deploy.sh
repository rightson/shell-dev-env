#!/bin/bash

SCRIPT_LOCATION=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
SCRIPT_LOC_ESCAPED=$(echo $SCRIPT_LOCATION | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/*/\\\&/g')
DEPLOYED_LOCATION=$SCRIPT_LOCATION_TAG/deployed-location

RC_TEMPLATE_LOC=$SCRIPT_LOCATION/rc
BASHRC=$HOME/.bash_profile
if [ "`uname`" = "Linux" ]; then
    BASHRC=$HOME/.bashrc
fi
VIMRC=$HOME/.vimrc
SCREENRC=$HOME/.screenrc
RC_FILES=("$BASHRC|bashrc" "$VIMRC|vimrc" "$SCREENRC|screenrc")

IDENTIFIER='Added by shell-dev-env.'

deploy_rc_files() {
    echo "Deploying the RC files..."
    for each in ${RC_FILES[@]}; do
        local rc_file=`echo $each | cut -d "|" -f 1`
        local rc_tmpl=`echo $each | cut -d "|" -f 2`
        if [ ! -f $rc_file ]; then
            echo "Creating $rc_file ... "
            touch $rc_file
        fi
        if [ -z "`grep \"$IDENTIFIER\" $rc_file`" ]; then
            echo -n "    Patching $rc_tmpl: $rc_file ..."
	        cat $RC_TEMPLATE_LOC/$rc_tmpl | \
            sed "s/S_LOC/$(echo $SCRIPT_LOC_ESCAPED)/g" >> $rc_file
            echo " done"
        fi
        local softlink=$SCRIPT_LOCATION/$rc_tmpl
        if [ ! -f $softlink ]; then
            echo "    Creating softlink for $rc_file at $softlink"
            ln -s $rc_file $softlink
        fi
    done
}

undeploy_rc_files() {
    echo "Restoring the settings..."
    for each in ${RC_FILES[@]}; do
        local rc_file=`echo $each | cut -d "|" -f 1`
        if [ ! -z "`grep \"$IDENTIFIER\" $rc_file`" ]; then
            local offsets=(`cat $rc_file | grep -E 'Added by shell-dev-env|=End=|=Begin' -n | cut -d ':' -f 1`)
            if [ $((${offsets[0]} + 1)) -eq ${offsets[1]} ]; then
                echo -n "    Restoring $rc_file..."
                sed "$((${offsets[0]}-1)),$((${offsets[2]}+1))d" -i $rc_file
                echo " done"
            fi
        fi
    done
}

create_env_path_tag() {
    echo $SCRIPT_LOCATION > $DEPLOYED_LOCATION
}

get_env_path_tag() {
    if [ -f $DEPLOYED_LOCATION ]; then
        cat $DEPLOYED_LOCATION
    else
        echo $SCRIPT_LOCATION
    fi
}

relocate_env_path() {
    local _SCRIPT_LOC=`get_env_path_tag`
    local _BASH_RC=$_SCRIPT_LOC/env/bash/*.bashrc
    local _BINARY=$_SCRIPT_LOC/bin/list-svn-diff.sh

    echo "Locating the ENV_PATH to $SCRIPT_LOCATION..."
    echo "    Processing $_BASH_RC... done"
    echo "    Processing $_BINARY... done"
    sed "s/export ENV_PATH=.*$/export ENV_PATH=$(echo $SCRIPT_LOC_ESCAPED)/g" -i $_BASH_RC $_BINARY
    echo ''
    echo 'Please run below command to complete the process manually:'
    echo ''
    echo "    source $BASHRC"
    echo ''
}

patch_everything() {
    echo "Deoplying $SCRIPT_LOCATION..."
    undeploy_rc_files
    deploy_rc_files 
    relocate_env_path
}

usage() {
    echo "Usage" 
    echo "  `basename $0` [help|apply|restore|relocate]" 
    echo "" 
    echo "Options" 
    echo "  help     - show this help" 
    echo "  apply    - deploy everything (default action)" 
    echo "  restore  - restore everything (bashrc, vimrc, screenrc)" 
    echo "  relocate - relocate the ENV_PATH (the location of this package)" 
    echo "" 
    exit
}

case $1 in
    help|h|-h)
        usage
        ;;
    restore)
        undeploy_rc_files 
        ;;
    relocate)
        relocate_env_path
        undeploy_rc_files 2>&1 > /dev/null
        deploy_rc_files 2>&1 > /dev/null
        ;;
    apply|*)
        patch_everything
        ;;
esac

