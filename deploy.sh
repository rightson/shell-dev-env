#!/bin/bash

SCRIPT_LOCATION=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
SCRIPT_LOC_ESCAPED=$(echo $SCRIPT_LOCATION | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/*/\\\&/g')

RC_TEMPLATE_LOC=$SCRIPT_LOCATION/rc
BASHRC=$HOME/.bash_profile
ZSHRC=$HOME/.zshrc
UNAME=`uname`
if [ $UNAME = "Linux" ]; then
    BASHRC=$HOME/.bashrc
fi
VIMRC=$HOME/.vimrc
SCREENRC=$HOME/.screenrc
TMUXCFG=$HOME/.tmux.conf
RC_FILES=("$BASHRC|bashrc" "$VIMRC|vimrc" "$SCREENRC|screenrc" "$TMUXCFG|tmux.conf" "$ZSHRC|zshrc")

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
                if [ $UNAME = "Linux" ]; then
                    sed "$((${offsets[0]}-1)),$((${offsets[2]}+1))d" -i $rc_file
                else
                    sed -i "" "$((${offsets[0]}-1)),$((${offsets[2]}+1))d" $rc_file
                fi
                echo " done"
            fi
        fi
    done
}

relocate_env_path() {
    local _BASH_RC=$SCRIPT_LOCATION/env/bash/*.bashrc
    local _BINARY=$SCRIPT_LOCATION/bin/list-svn-diff.sh

    echo "Locating the ENV_PATH to $SCRIPT_LOCATION..."
    echo "    Processing $_BASH_RC... done"
    echo "    Processing $_BINARY... done"

    if [ $UNAME = "Linux" ]; then
        sed "s/export ENV_PATH=.*$/export ENV_PATH=$(echo $SCRIPT_LOC_ESCAPED)/g" -i $_BASH_RC $_BINARY
    else
        sed -i "" "s/export ENV_PATH=.*$/export ENV_PATH=$(echo $SCRIPT_LOC_ESCAPED)/g" $_BASH_RC $_BINARY
    fi

    echo ''
    echo 'Please run below command to complete the process manually:'
    echo ''
    echo "    source $BASHRC"
    echo ''
}

patch_everything() {
    echo "Deoplying $SCRIPT_LOCATION..."
    deploy_rc_files 
    relocate_env_path
}

relocate_deployment() {
    echo "Relocating $SCRIPT_LOCATION..."
    undeploy_rc_files 
    deploy_rc_files
    relocate_env_path
}

usage() {
    echo "Usage" 
    echo "  $0 [all|restore|relocate]" 
    echo "" 
    echo "Options" 
    echo "  all      - deploy everything (default action)" 
    echo "  restore  - restore everything (bashrc, vimrc, screenrc)" 
    echo "  relocate - relocate the ENV_PATH (the location of this package)" 
    echo "" 
    exit
}

case $1 in
    restore)
        undeploy_rc_files
        ;;
    relocate)
        relocate_deployment
        ;;
    all)
        patch_everything
        ;;
    *)
        usage
        ;;
esac

