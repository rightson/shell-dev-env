#!/bin/bash

export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)

source ${ENV_ROOT}/inc/base.sh
source ${ENV_ROOT}/inc/install.sh

if [ ${#@} -eq 0 ]; then
    print_usage $0
    $SHELL
fi

for var in "$@"; do
    case "$var" in
        patch)
            patch_rc_files $SHELL_NAME $ENV_SHELL
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
            patch_rc_files $SHELL_NAME $ENV_SHELL
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
