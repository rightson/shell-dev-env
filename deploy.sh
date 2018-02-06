#!/bin/bash

ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
ENV_ROOT_VARIABLE=${BASE_ROOT/$HOME/\$HOME}
ENV_ROOT_ESCAPED=$(echo $ENV_ROOT | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/*/\\\&/g')
RC_ROOT=$ENV_ROOT/rc
RC_DEPLOYED=$ENV_ROOT/rc-deployed

case $(basename $SHELL) in
    zsh)
        SHELL_RC_NAME=zshrc;;
    tcsh)
        SHELL_RC_NAME=tcshrc;;
    *)
        SHELL_RC_NAME=bashrc;;
esac
if [ -z $PROFILE ]; then
    case `basename $SHELL` in
        zsh)
            export PROFILE=~/.zshrc;;
        csh|tcsh)
            export PROFILE=~/.cshrc;;
        *)
            export PROFILE=~/.bashrc;;
    esac
fi
SHELLRC=${PROFILE/#\~/$HOME}
VIMRC=$HOME/.vimrc
SCREENRC=$HOME/.screenrc
TMUXCFG=$HOME/.tmux.conf
RC_FILES=("$SHELLRC|$SHELL_RC_NAME" "$VIMRC|vimrc" "$SCREENRC|screenrc" "$TMUXCFG|tmux.conf")

IDENTIFIER='Added by shell-dev-env.'

deploy_rc_files() {
    echo "Deploying the RC files ..."
    for each in ${RC_FILES[@]}; do
        local rc_file=`echo $each | cut -d "|" -f 1`
        local rc_tmpl_name=`echo $each | cut -d "|" -f 2`
        local rc_tmpl="$RC_ROOT/$rc_tmpl_name"

        if [ ! -f $rc_file ]; then
            echo "Creating [$rc_file] ... "
            cp -f $rc_tmpl $rc_file
        fi

        if [ "`grep \"$IDENTIFIER\" $rc_file 2> /dev/null`" = "" ]; then
            echo "Adding RC template to $rc_file ..."
            cat $rc_tmpl >> $rc_file
        fi

        echo "Patching RC file [$rc_file] ..."
        if [ `uname -s` = Darwin ]; then
            TMP=tmp
        fi
        sed -i $TMP "s/\$ENV_ROOT/$ENV_ROOT_ESCAPED/g" $rc_file

        local rc_reverse_link=${RC_DEPLOYED}/$rc_tmpl_name
        if [ ! -f $rc_reverse_link ]; then
            mkdir -p $RC_DEPLOYED
            ln -fs $rc_file $rc_reverse_link
        fi
    done
    echo "Deployment Completed"
}

undeploy_rc_files() {
    echo "Restoring the settings ..."
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
    local _BASH_RC=$ENV_ROOT/env/bash/*.bashrc
    local _BINARY=$ENV_ROOT/bin/list-svn-diff.sh

    echo "Locating the ENV_PATH to $ENV_ROOT..."
    echo "    Processing $_BASH_RC... done"
    echo "    Processing $_BINARY... done"

    if [ $UNAME = "Linux" ]; then
        sed "s/export ENV_PATH=.*$/export ENV_PATH=$(echo $ENV_ROOT_ESCAPED)/g" -i $_BASH_RC $_BINARY
    else
        sed -i "" "s/export ENV_PATH=.*$/export ENV_PATH=$(echo $ENV_ROOT_ESCAPED)/g" $_BASH_RC $_BINARY
    fi

    echo ''
    echo 'Please run below command to complete the process manually:'
    echo ''
    echo "    source $PROFILE"
    echo ''
}

patch_everything() {
    echo "Deoplying $ENV_ROOT ..."
    deploy_rc_files
    #relocate_env_path
}

relocate_deployment() {
    echo "Relocating $ENV_ROOT ..."
    undeploy_rc_files
    deploy_rc_files
    #relocate_env_path
}

case $1 in
    #restore)
    #    undeploy_rc_files
    #    ;;
    #relocate)
    #    relocate_deployment
    #    ;;
    #all)
    #    ;;
    *)
        #usage
        patch_everything
        ;;
esac

