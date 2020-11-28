#!/bin/bash

export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)

if [ "$0" = "${BASH_SOURCE}" ]; then
    export ENV_RUN_MODE=bash
    export ENV_SHELL=$(which `ps -p$PPID | tail -1 | awk '{print $NF}' | xargs basename | tr -cd '[:alnum:]'`)
else
    export ENV_RUN_MODE=source
    export ENV_SHELL=$(which $0)
fi


ENV_LIB=${ENV_ROOT}/inc/install.sh
[ -f $ENV_LIB ] && . $ENV_LIB

if [ $ENV_RUN_MODE = bash ]; then
    if [ ${#@} -eq 0 ]; then
        print_usage $0
    fi
    for var in "$@"; do
        case "$var" in
            patch)
                patch_rc_files $ENV_RUN_MODE $ENV_SHELL
                ;;
            install)
                install_vim_plug
                install_tmux_tpm
                install_fzf
                ;;
            config)
                config_vim_plug
                config_git_vim_diff
                ;;
            all)
                patch_rc_files $ENV_RUN_MODE $ENV_SHELL
                install_vim_plug
                install_tmux_tpm
                install_fzf
                config_vim_plug
                config_git_vim_diff
                ;;
            *)
                print_usage $0
                ;;
        esac
    done
    exit 0
fi
