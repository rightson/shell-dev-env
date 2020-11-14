#!/bin/bash

export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)

if [ "$0" = "${BASH_SOURCE}" ]; then
    export ENV_RUN_MODE=bash
    export ENV_SHELL=$(which `ps -p$PPID | tail -1 | awk '{print $NF}' | xargs basename | tr -cd '[:alnum:]'`)
else
    export ENV_RUN_MODE=source
    export ENV_SHELL=$(which $0)
fi

ENV_LIB=${ENV_ROOT}/inc/lib.sh
[ -f $ENV_LIB ] && . $ENV_LIB

if [ $ENV_RUN_MODE = bash ]; then
    case "$1" in
        install)
            install_vim_plug
            install_tmux_tpm
            install_fzf
            config_git_vim_diff
            ;;
        *)
            print_usage $0 
            ;;
    esac
    exit 0
fi
