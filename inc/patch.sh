
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

function get_patched_rc() {
    if [ "$1" = "" ]; then
        echo "Usage: get_patched_rc <snell-name>"
        return
    fi
    local shell_name=$1
    local rc=`get_shell_rc_path $shell_name`
    local begin=`get_line_number "$ENV_BLOCK_HEAD" $rc`
    local end=`get_line_number "$ENV_BLOCK_END" $rc`
    echo -e "\n# $ENV_BLOCK_HEAD"
    if [ $shell_name = tcsh ]; then
        echo "setenv ENV_ROOT $ENV_ROOT"
    else
        echo "export ENV_ROOT=$ENV_ROOT"
    fi
    cat $ENV_ROOT/seeds/${shell_name}rc
    echo -e "# $ENV_BLOCK_END\n"
}

function patch_shell_rc() {
    if [ "$1" = "" ] || [ "$2" = "" ]; then
        echo "Usage: patch_shell_rc <snell-name> <rc-path>"
        return
    fi
    local shell_name=$1
    local rc=$2
    if [ "`grep \"$ENV_BLOCK_HEAD\" $rc 2> /dev/null`" != "" ]; then
        echo "$2 already patched"
        return
    fi
    local temp=`mktemp`
    cat $rc > $temp
    get_patched_rc $shell_name >> $temp
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
    local local_vimrc=$HOME/.vimrc.plug
    if [ "`grep \"$ENV_BLOCK_HEAD\" $vimrc 2> /dev/null`" = "" ]; then
        echo "Patching $vimrc ..."
        echo -e "\n\" $ENV_BLOCK_HEAD" >> $vimrc
        echo "\" =Begin=" >> $vimrc
        echo "source $ENV_ROOT/vim/plug.vimrc" >> $vimrc
        echo "\" Update local Plug at $local_vimrc" >> $vimrc
        echo "source $ENV_ROOT/vim/helpers.vimrc" >> $vimrc
        echo "source $ENV_ROOT/vim/hotkeys.vimrc" >> $vimrc
        echo "source $ENV_ROOT/vim/setting.vimrc" >> $vimrc
        echo "\" =END=" >> $vimrc
	touch $local_vimrc
    else
        echo "$vimrc already patched"
    fi
}

function patch_nvim_rc() {
    local nvimrc=$HOME/.config/nvim/init.vim
    local local_nvimrc=$HOME/.config/nvim/extra-plug.vim
    mkdir -p `dirname $nvimrc`;
    mkdir -p `dirname $local_nvimrc`;
	touch $local_nvimrc
    if [ "`grep \"$ENV_BLOCK_HEAD\" $nvimrc 2> /dev/null`" = "" ]; then
        echo "Patching $nvimrc ..."
        cat "${ENV_ROOT}/seeds/nvimrc" >> $nvimrc
        # echo -e "\n\" $ENV_BLOCK_HEAD" >> $nvimrc
        # echo "\" =Begin=" >> $nvimrc
        # echo "source $ENV_ROOT/vim/plug.vimrc" >> $nnvimrc
        # echo "\" Update local Plug at $local_nvimrc" >> $nvimrc
        # echo "source $ENV_ROOT/vim/helpers.vimrc" >> $nvimrc
        # echo "source $ENV_ROOT/vim/hotkeys.vimrc" >> $nvimrc
        # echo "source $ENV_ROOT/vim/setting.vimrc" >> $nvimrc
        # echo "\" =END=" >> $nvimrc
    else
        echo "$nvimrc already patched"
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

function patch_hammerspoon() {
    local hammerspoon_init=$HOME/.hammerspoon/init.lua
    local seed_file="${ENV_ROOT}/seeds/hammerspoon/init.lua"

    # Create directory if it doesn't exist
    mkdir -p `dirname $hammerspoon_init`

    # Backup existing file if present
    if [ -f "$hammerspoon_init" ]; then
        local ts=`date +%Y-%m-%d-%H-%M-%S`
        echo "Backing up $hammerspoon_init to $hammerspoon_init.bak-$ts"
        cp "$hammerspoon_init" "$hammerspoon_init.bak-$ts"
    fi

    # Copy seed file to target
    echo "Copying Hammerspoon config from $seed_file to $hammerspoon_init"
    cp "$seed_file" "$hammerspoon_init"
}

function patch_karabiner() {
    local karabiner_config=$HOME/.config/karabiner/karabiner.json
    local seed_file="${ENV_ROOT}/seeds/karabiner/karabiner.json"

    # Create directory if it doesn't exist
    mkdir -p `dirname $karabiner_config`

    # Backup existing file if present
    if [ -f "$karabiner_config" ]; then
        local ts=`date +%Y-%m-%d-%H-%M-%S`
        echo "Backing up $karabiner_config to $karabiner_config.bak-$ts"
        cp "$karabiner_config" "$karabiner_config.bak-$ts"
    fi

    # Copy seed file to target
    echo "Copying Karabiner config from $seed_file to $karabiner_config"
    cp "$seed_file" "$karabiner_config"
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
    patch_nvim_rc
    patch_hammerspoon
    patch_karabiner

    echo "Please run below command to update your shell setting:"
    echo -e "\n\tsource $rc\n"
}
