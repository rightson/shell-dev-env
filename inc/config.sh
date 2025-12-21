# Config

function config_vim_plug() {
    local target_root="${TARGET_ROOT:-$HOME}"
    vim -E -s -u "$target_root/.vimrc" +PlugInstall +qall
}

function config_git_vim_diff() {
    git config --global diff.tool vimdiff
    git config --global difftool.prompt false
    git config --global alias.vimdiff difftool
}

function config_git_core_editor() {
    git config --global core.editor 'vim'
}

function config_git_cache_timeout() {
    local timeout=$1
    if [ -z "$timeout" ]; then
        local timeout=8640000
    fi
    git config --global credential.helper "cache --timeout $timeout"
}
