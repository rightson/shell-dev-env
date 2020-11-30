#!/bin/bash

export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)

source ${ENV_ROOT}/inc/base.sh
source ${ENV_ROOT}/inc/install.sh
source ${ENV_ROOT}/inc/config.sh

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
    export SHELL_PATH=$(which `ps -p$PPID | tail -1 | awk '{print $NF}' | xargs basename | tr -cd '[:alnum:]'`)
fi
export SHELL_NAME=`basename $SHELL_PATH`

if [ ${#@} -eq 0 ]; then
    print_usage $0
    exit 0
fi

for var in "$@"; do
    case "$var" in
        patch)
            patch_rc_files $SHELL_NAME
            ;;
        install)
            install_vim_plug
            install_tmux_tpm
            install_fzf
            ;;
        config)
            config_vim_plug
            config_git_vim_diff
            config_git_core_editor
            config_git_cache_timeout
            ;;
        config-git)
            config_git_vim_diff
            config_git_core_editor
            config_git_cache_timeout
            ;;
        all)
            patch_rc_files $SHELL_NAME
            install_vim_plug
            install_tmux_tpm
            install_fzf
            config_vim_plug
            config_git_vim_diff
            config_git_core_editor
            config_git_cache_timeout
            ;;
        *)
            print_usage $0
            ;;
    esac
done
exit 0
