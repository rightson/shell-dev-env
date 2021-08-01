
ENV_BLOCK_HEAD='Added by shell-env.sh utility'
ENV_BLOCK_BEGIN='=Begin='
ENV_BLOCK_END='=End='

function get_line_number() {
    if [ "$1" = "" ] || [ "$2" = "" ]; then
        echo "Usage: get_line_number <pattern> <file>"
        return
    fi
    local pattern="$1"
    local file="$2"
    grep -n "$pattern" "$file" | cut -d: -f1
}

function get_shell_rc_path() {
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
            echo "Unsupported shell (only supports csh, bash and zsh)"
            return
            ;;
    esac
}

function get_new_shell_rc() {
    if [ "$1" = "" ]; then
        echo "Usage: get_new_shellrc <snell-name>"
        return
    fi
    local shell_name=$1
    local rc=`get_shell_rc_path $shell_name`
    local begin=`get_line_number "$ENV_BLOCK_HEAD" $rc`
    local end=`get_line_number "$ENV_BLOCK_END" $rc`
    head -n $begin $rc
    echo "# $ENV_BLOCK_BEGIN"
    if [ $shell_name = tcsh ]; then
        echo "setenv ENV_ROOT $ENV_ROOT"
    else
        echo "export ENV_ROOT=$ENV_ROOT"
    fi
    cat $ENV_ROOT/seeds/${shell_name}rc
    echo "# $ENV_BLOCK_END"
    tail -n +`echo $end+1|bc` $rc|grep -E -v 'env_use_|use_env_'
}

function patch_shell_rc() {
    if [ "$1" = "" ] || [ "$2" = "" ]; then
        echo "Usage: patch_shell_rc <snell-name> <rc-path>"
        return
    fi
    local shell_name=$1
    local rc=$2
    local temp=`mktemp`
    get_new_shell_rc $shell_name > $temp
    mv $rc ${rc}-`date +%F-%H-%M-%S`.bak
    mv $temp $rc
    echo "$rc patched"
}

function patch_tmux_rc() {
    local tmuxrc=$HOME/.tmux.conf
    if [ "`grep \"$ENV_BLOCK_HEAD\" $tmuxrc 2> /dev/null`" = "" ]; then
        echo "Patching $tmuxrc ... "
        cat "${ENV_ROOT}/seeds/tmux.conf" >> $tmuxrc
    else
        echo "$tmuxrc already patched"
    fi

}

function patch_vim_rc() {
    local vimrc=$HOME/.vimrc
    if [ "`grep \"$ENV_BLOCK_HEAD\" $vimrc 2> /dev/null`" = "" ]; then
        echo "Patching $vimrc ..."
        echo -e "\n\" $ENV_BLOCK_HEAD" >> $vimrc
        echo "\" =Begin=" >> $vimrc
        echo "source $ENV_ROOT/vim/plug.vimrc" >> $vimrc
        echo "source $ENV_ROOT/vim/helpers.vimrc" >> $vimrc
        echo "source $ENV_ROOT/vim/hotkeys.vimrc" >> $vimrc
        echo "source $ENV_ROOT/vim/setting.vimrc" >> $vimrc
        echo "\" =END=" >> $vimrc
    else
        echo "$vimrc already patched"
    fi
}

function patch_screen_rc() {
    local screenrc=$HOME/.screenrc
    if [ "`grep \"$ENV_BLOCK_HEAD\" $screenrc 2> /dev/null`" = "" ]; then
        echo "Patching $screenrc ... "
        cat "${ENV_ROOT}/seeds/screenrc" >> $screenrc
    else
        echo "$screenrc already patched"
    fi
}


function patch_rc_files() {
    if [ "$1" = "" ]; then
        echo "Usage: patch_rc_files <snell-name>"
        return
    fi
    local shell_name=$1
    echo "shell_name=$shell_name"
    local rc=`get_shell_rc_path $shell_name`
    echo "rc=$rc"

    patch_shell_rc $shell_name $rc
    patch_tmux_rc
    patch_vim_rc
    patch_screen_rc

    echo "Please run below command to update your shell setting:"
    echo -e "\n\tsource $rc\n"
}
