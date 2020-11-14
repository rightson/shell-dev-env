export __DIR__=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)

function print_usage() {
    echo "Usages:"
    echo "  Install mode:"
    echo "      $0 install"
    echo "  Source mode:"
    echo "      source $0"
}

function install_vim_plug() {
    echo "Installing vim-plug"
    if [ ! -f ~/.vim/autoload/plug.vim ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
}

install_tmux_tpm() {
    echo "Installing tmux-tpm"
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

install_fzf() {
    echo "Installing fzf"
    if [ ! -f ~/.fzf/install ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi
}

config_git_vim_diff() {
    git config --global diff.tool vimdiff
    git config --global difftool.prompt false
    git config --global alias.vimdiff difftool
}

