# SSH

export MY_SSH_TARGET_CACHG=$HOME/.cache/my-ssh-target-cache

function get_ssh_target_cache() {
    local remote=$1
    if [ -n "$remote" ]; then
        echo $remote;
        return $EXIT_FAILURE;
    fi
    if [ -z "$remote" ] && [ -s $MY_SSH_TARGET_CACHG ]; then
        cat $MY_SSH_TARGET_CACHG;
    else
        die "Please specify remote address";
    fi
    return $EXIT_SUCCESS;
}

function set_ssh_target_cache() {
    local remote=$1
    if [ -n "$remote" ]; then
        mkdir -p `dirname $MY_SSH_TARGET_CACHG`
        echo $remote > $MY_SSH_TARGET_CACHG;
        return $EXIT_SUCCESS;
    fi
    return $EXIT_FAILURE;
}

function clean_ssh_target_cache() {
    echo "" > $MY_SSH_TARGET_CACHG;
}

