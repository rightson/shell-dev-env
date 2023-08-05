# Install

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

function install_nvm() {
    which nvm 2> /dev/null
    if [ $? -eq 0 ]; then
        echo "nvm already installed"
        return
    fi
    if [ -n "`which curl 2> /dev/null`" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
    else
        wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
    fi
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

function install_go() {
    set -x
    local tarball="https://go.dev/dl/go1.20.7.linux-amd64.tar.gz"
    local basename=`pwd`/`basename $tarball`
    if [ ! -f $basename ]; then
        wget $tarball
    fi
    local dest=$HOME/local/opt
    if [ ! -d $dst/go ]; then
        mkdir -p $dest
    else
        rm -rf $dst/go
    fi
    cd $dest
    tar zxf $basename
    rm $basename

    local bin=$HOME/local/bin
    cd $bin
    ln -fs ../opt/go/bin/go
    ln -fs ../opt/go/bin/gofmt
    set +x
}
