#!/bin/bash

ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
ENV_ROOT_VARIABLE=${BASE_ROOT/$HOME/\$HOME}
ENV_ROOT_ESCAPED=$(echo $ENV_ROOT | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/*/\\\&/g')
RC_ROOT=$ENV_ROOT/rc
RC_DEPLOYED=$ENV_ROOT/rc-deployed

shell=`ps -p$PPID | tail -1 | awk '{print $NF}'`
echo $shell
case $shell in
    csh)
        SHELL_RC_NAME=tcshrc
        PROFILE=~/.cshrc
        ;;
    bash)
        SHELL_RC_NAME=bashrc
        PROFILE=~/.bashrc
        ;;
    zsh)
        SHELL_RC_NAME=zshrc
        PROFILE=~/.zshrc
        ;;
    *)
        echo "Unsupported shell"
        exit -1
        ;;
esac

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

relocate_env_path() {
    local _BASH_RC=$ENV_ROOT/env/bash/*.bashrc
    local _BINARY=$ENV_ROOT/bin/list-svn-diff.sh

    echo "Locating the ENV_ROOT to $ENV_ROOT..."
    echo "    Processing $_BASH_RC... done"
    echo "    Processing $_BINARY... done"

    if [ $UNAME = "Linux" ]; then
        sed "s/export ENV_ROOT=.*$/export ENV_ROOT=$(echo $ENV_ROOT_ESCAPED)/g" -i $_BASH_RC $_BINARY
    else
        sed -i "" "s/export ENV_ROOT=.*$/export ENV_ROOT=$(echo $ENV_ROOT_ESCAPED)/g" $_BASH_RC $_BINARY
    fi

    echo ''
    echo 'Please run below command to complete the process manually:'
    echo ''
    echo "    source $PROFILE"
    echo ''
}

install_vim_plug() {
    echo "Configuring vim plug"
    if [ ! -f ~/.vim/autoload/plug.vim ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
}

install_tmux_tpm() {
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

deb_download_and_install() {
    if [ "$distro" = "\"Ubuntu\"" ]; then
        url=$1
        wget $url
        pkg=./`basename $url`
        sudo apt install -y $pkg
        \rm -f $pkg
    else
        echo "Disable deb was downloaded (not Ubuntu)"
    fi
}

install_fd_for_ubuntu() {
    distro=`cat /etc/os-release | grep '^NAME=' | awk -F '=' '{print $2 }'`
    if [ "$distro" != "\"Ubuntu\"" ]; then
        echo "Not ubuntu, please install fd from https://github.com/sharkdp/fd/ manually"
        return
    fi
    dpkg -s fd-musl | grep installed > /dev/null
    if [ $? -eq 0 ]; then
        return
    fi
    if [ "`which fd`" != ""  ]; then
        deb_download_and_install https://github.com/sharkdp/fd/releases/download/v7.0.0/fd-musl_7.0.0_amd64.deb
    fi
}

install_fzf() {
    if [ ! -f ~/.fzf/install ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi
}

install_rg() {
    distro=`cat /etc/os-release | grep '^NAME=' | awk -F '=' '{print $2 }'`
    if [ "`which brew`" != ""  ]; then
        brew install ripgrep
    elif [ "`which rg`" = "" ] && [ "$distro" = "\"Ubuntu\"" ]; then
        deb_download_and_install =https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
    fi
}

patch_git_vim_diff() {
    git config --global diff.tool vimdiff
    git config --global difftool.prompt false
    git config --global alias.vimdiff difftool
}

patch_minimal_things() {
    deploy_rc_files
    patch_git_vim_diff
}

patch_everything() {
    echo "Deoplying $ENV_ROOT ..."
    deploy_rc_files
    patch_git_vim_diff
    install_vim_plug
    install_tmux_tpm
    install_fd_for_ubuntu
    install_fzf
    #install_rg
    #relocate_env_path
}

case $1 in
    min*)
        echo "Deoplying minimal $ENV_ROOT ..."
        patch_minimal_things
        ;;
    func)
        shift;
        $1;
        ;;
    *)
        patch_everything
        ;;
esac
