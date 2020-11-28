# Install

function print_usage() {
    echo "Usages:"
    echo "  Command line mode:"
    echo "      $0 patch|install|config|all"
    echo "  Source mode:"
    echo "      source $0"
}

function install_vim_plug() {
    echo "Installing vim-plug"
    if [ ! -f ~/.vim/autoload/plug.vim ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo "vim-plug installation completed" 
    else
        echo "vim-plug alredy installed"
    fi
}

function install_tmux_tpm() {
    echo "Installing tmux-tpm"
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        echo "tmux-tpm installation completed"
    else
        echo "tmux-tpm alredy installed"
    fi
}

function install_fzf() {
    echo "Installing fzf ..."
    if [ ! -f ~/.fzf/install ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
        echo "fzf installation completed" 
    else 
        echo "fzf already installed" 
    fi
}

function config_vim_plug() {
    vim -E -s -u "~/.vimrc" +PlugInstall +qall
}

function config_git_vim_diff() {
    git config --global diff.tool vimdiff
    git config --global difftool.prompt false
    git config --global alias.vimdiff difftool
}

function install_chrome_from_deb() {
    local file=google-chrome-stable_current_amd64.deb
    local url=https://dl.google.com/linux/direct/$file
    if [ -f ./$file ]; then
        rm -f ./$file
    fi
    wget $url
    if [ $? -eq 0 ]; then
        sudo apt install -y ./$file
        rm -f ./$file
    fi
}

function get_target_profile() {
    case "$1" in
        *csh)
            echo "$HOME/.cshrc"
            ;;
        *bash)
            echo "$HOME/.bashrc"
            ;;
        *zsh)
            echo "$HOME/.zshrc"
            ;;
        *)
            echo "Unsupported shell"
            exit -1
            ;;
    esac
}

function get_target_profile() {
    case "$1" in
        *csh)
            echo "$HOME/.cshrc"
            ;;
        *bash)
            echo "$HOME/.bashrc"
            ;;
        *zsh)
            echo "$HOME/.zshrc"
            ;;
        *)
            echo "Unsupported shell"
            exit -1
            ;;
    esac
}

function patch_rc_files() {
    local shell_name=$1
    local shell=$2
    local profile=`get_target_profile $shell_name`

    local IDENTIFIER='Added by shell-env.sh.'
    if [ "`grep \"$IDENTIFIER\" $profile 2> /dev/null`" = "" ]; then
        echo "Patching $profile ... "
        echo -e "\n# $IDENTIFIER" >> $profile
        echo "# =Begin=" >> $profile
        echo "export ENV_ROOT=$ENV_ROOT" >> $profile
        echo "source \$ENV_ROOT/inc/env.${shell_name}" >> $profile
        echo "# =End=" >> $profile
    else 
        echo "$profile already patched" 
    fi

    local vimrc=$HOME/.vimrc
    if [ "`grep \"$IDENTIFIER\" $vimrc 2> /dev/null`" = "" ]; then
        echo "Patching $vimrc ..."
        echo -e "\n\" $IDENTIFIER" >> $vimrc
        echo "\" =Begin=" >> $vimrc
        echo "source $ENV_ROOT/vim/plug.vimrc" >> $vimrc
        echo "source $ENV_ROOT/vim/helpers.vimrc" >> $vimrc
        echo "source $ENV_ROOT/vim/hotkeys.vimrc" >> $vimrc
        echo "source $ENV_ROOT/vim/setting.vimrc" >> $vimrc
        echo "\" =END=" >> $vimrc
    else 
        echo "$vimrc already patched" 
    fi

    local tmuxrc=$HOME/.tmuxrc
    if [ "`grep \"$IDENTIFIER\" $tmuxrc 2> /dev/null`" = "" ]; then
        echo "Patching $tmuxrc ... "
        cat "${ENV_ROOT}/seeds/tmux.conf" >> $tmuxrc
    else
        echo "$tmuxrc already patched" 
    fi

    echo "Please run below command to update your shell setting:"
    echo -e "\n\tsource $profile\n"
}
