# RDP remote helper

export MY_RDP_PORT=3389
export MY_RDP_IP_CACHE=$HOME/.cache/my-rdp-ip-cache

function insert_unique_line_to_file () {
    local line=$1
    local file=$2
    if [ -n "$line" ]; then
        grep $line $file > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo $line >> $file
            return $EXIT_SUCCESS;
        fi
    fi
    return $EXIT_FAILURE;
}

function remove_line_from_file () {
    local line=$1
    local file=$2
    if [ -n "$line" ]; then
        grep -v $line $file | tee $file > /dev/null
        return $EXIT_SUCCESS;
    fi
    return $EXIT_FAILURE;
}


function add_rdp_rule() {
    if [ -z $TARGET_SSH_URL ]; then
        echo "Please set value to \$TARGET_SSH_URL";
        return $EXIT_FAILURE;
    fi
    if [ `is_gw_good` -ne $EXIT_SUCCESS ]; then
        echo "No good gateway available";
        return $EXIT_FAILURE;
    fi
    if [ -s $MY_RDP_IP_CACHE ]; then
        local ip=`get_current_ip`
        if [ "`grep -w $ip $MY_RDP_IP_CACHE`" = "$ip" ]; then
            if [ $? -ne 0 ]; then
                echo "Rule already installed to remote's firewall";
                return $EXIT_SUCCESS;
            fi
        fi
    fi
    insert_unique_line_to_file `get_current_ip` $MY_RDP_IP_CACHE
    remote_ufw_allow_rdp $TARGET_SSH_URL
    return $?;
}

function remove_rdp_rules() {
    if [ -z $TARGET_SSH_URL ]; then
        echo "Please set value to \$TARGET_SSH_URL";
        return $EXIT_FAILURE;
    fi
    if [ "`is_gw_good`" -ne "$EXIT_SUCCESS" ]; then
        echo "No good gateway available";
        return $EXIT_FAILURE;
    fi
    if [ -s $MY_RDP_IP_CACHE ]; then
        cat $MY_RDP_IP_CACHE | while read line; do
            if [ -z "$line" ]; then continue; fi
            remote_ufw_delete_allow_rdp $TARGET_SSH_URL $line
            remove_line_from_file $line $MY_RDP_IP_CACHE
        done
        remote_ufw_status $TARGET_SSH_URL
    fi
    return $EXIT_SUCCESS;
}

function update_rdp_rules() {
    remove_rdp_rules $@
    add_rdp_rule $@
}

function remote_ufw_allow_rdp() {
    local remote=`get_ssh_target_cache $1`
    local ip=$2
    if [ -z "$ip" ]; then
        ip=`get_current_ip`;
    fi
    remote_ufw_allow $remote $ip $MY_RDP_PORT || true;
    set_ssh_target_cache $remote
    return $?;
}

function remote_ufw_delete_allow_rdp() {
    local remote=`get_ssh_target_cache $1`
    local ip=$2
    if [ -z "$ip" ]; then
        ip=`get_current_ip`;
    fi
    remote_ufw_delete_allow $remote $ip $MY_RDP_PORT
    set_ssh_target_cache $remote
    return $?;
}

