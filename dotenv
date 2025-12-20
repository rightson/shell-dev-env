#!/bin/bash

export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)

source ${ENV_ROOT}/inc/base.sh
source ${ENV_ROOT}/inc/install.sh
source ${ENV_ROOT}/inc/config.sh
source ${ENV_ROOT}/inc/patch.sh

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
    SHELL_NAME=`ps -p$PPID | tail -1 | awk '{print $NF}' | tr -cd '[:alnum:]/' | xargs basename`
    export SHELL_PATH=$(which $SHELL_NAME)
fi
export SHELL_NAME=`basename ${SHELL_PATH:-bash}`

function print_usage() {
    echo "Usages: $0 patch|install|config|all"
}

function patch() {
    echo 'Patching rc ...'
    patch_rc_files $SHELL_NAME
}

function install() {
    echo 'Installing vim/tmux_tpm/fzf ...'
    install_vim_plug
    install_tmux_tpm
    install_fzf
}

function config_git() {
    echo 'Configuring git ...'
    config_git_vim_diff
    config_git_core_editor
    config_git_cache_timeout
}

function config_vim() {
    echo 'Configuring vim ...'
    config_vim_plug
}

function config() {
    config_git
    config_vim
}

function default_action() {
    patch
    install
    config
}

if [ ${#@} -eq 0 ]; then
    default_action
    exit 0
fi

for var in "$@"; do
    case "$var" in
        patch)
            patch;;
        install)
            install;;
        config)
            config;;
        config-git)
            config_git;;
        config-vim)
            config_vim;;
        -h|--help|--usage|-H)
            print_usage $0;;
        *)
            default_action
            ;;
    esac
done
