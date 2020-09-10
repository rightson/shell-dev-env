#!/bin/bash -x

### Variables ###

# general
export EXIT_SUCCESS=0
export EXIT_FAILURE=-1
# for route
export MY_GW_IP_CACHE=$HOME/.cache/my-gw-ip
# for ssh
export MY_SSH_TARGET_CACHG=$HOME/.cache/my-ssh-target-cache
# for ufw
# for rdp
export MY_RDP_PORT=3389
export MY_RDP_IP_CACHE=$HOME/.cache/my-rdp-ip-cache
export MY_METRIC=100


### General ###

function die() {
    echo $@;
    exit $EXIT_FAILURE;
}

function run() {
    echo $@;
    eval $@;
    return $?
}

function registerPath() {
    if [ -z $1 ]; then
        echo "Error: failed to register PATH: path not specified";
        return $EXIT_FAILURE;
    fi
    if [ ! -d $1 ]; then
        echo "Error: failed to register $1 to PATH: path $1 not existed";
        return $EXIT_FAILURE;
    fi
    export PATH=$1:$PATH
}

function registerLibrary() {
    if [ -z $1 ]; then
        echo "Error: failed to register LD_LIBRARY_PATH: path not specified";
        return $EXIT_FAILURE;
    fi
    if [ ! -d $1 ]; then
        echo "Error: failed to register $1 to LD_LIBRARY_PATH: path $1 not existed";
        return $EXIT_FAILURE;
    fi
    export LD_LIBRARY_PATH=$1:$LD_LIBRARY_PATH
}

function registerPathAndLibrary {
    registerPath $1/bin
    if [ $? -ne $EXIT_SUCCESS ]; then
        return $EXIT_FAILURE;
    fi
    registerLibrary $1/lib
    if [ $? -ne $EXIT_SUCCESS ]; then
        return $EXIT_FAILURE;
    fi
}

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

function get_current_ip() {
    local temp=`mktemp`;
    curl --insecure -s https://ipinfo.io > $temp
    if [ -s $temp ]; then
        cat $temp | python3 -c "import sys, json; print(json.load(sys.stdin)['ip'])"
    fi
    local ret=`test -s $temp`
    rm -f $temp
    if [ -n "$ret" ]; then
        return $EXIT_SUCCESS;
    else
        return $EXIT_FAILURE;
    fi
}


### Docker
function get_container_id() {
    local name=$1
    if [ -n "$name" ]; then
        echo $(docker ps | grep $name | awk '{ printf $1 }')
    fi
}

### For route ###

function is_gw_good() {
    if [ -f $MY_GW_IP_CACHE ]; then
        route -n | head -n 3 | tail -n 1 | grep `cat $MY_GW_IP_CACHE` > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo $EXIT_FAILURE
        else
            echo $EXIT_SUCCESS
        fi
    else
        echo $EXIT_SUCCESS
    fi
}

function add_gw_ip() {
    local ip=
    local msg="Enter desired gateway IP => "
    if [ -n "$ZSH_VERSION" ]; then
        vared -p "$msg" ip
    else
        read -p "$msg" ip
    fi
    echo $ip > $MY_GW_IP_CACHE
}

function route_add() {
    local gwip=`cat $MY_GW_IP_CACHE`
    local exists=`route -n | head -n 3 | grep $gwip`
    if [ -z "$exists" ]; then
        run sudo route add -net default gw $gwip metric $MY_METRIC
    fi
    route -n | grep $gwip
}

function route_del() {
    local gwip=`cat $MY_GW_IP_CACHE`
    run sudo route del -net default gw $gwip metric $MY_METRIC
    route -n
}

alias rn='route -n'
alias rs='add_gw_ip'
alias ra='route_add'
alias ra.='route_add > /dev/null && echo $?'
alias rc='route_del'
alias rc.='route_del > /dev/null && echo $?'


### For SSH ###

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


### For UFW ###

function ufw_status() {
    run sudo ufw status
}

function ufw_allow() {
    local ip=$1
    local port=$2
    run sudo ufw allow from $ip to any port $port
    return $?;
}

function ufw_delete_allow() {
    local ip=$1
    local port=$2
    run sudo ufw delete allow from $ip to any port $port
    return $?;
}

function remote_ufw_status() {
    local remote=`get_ssh_target_cache $1`
    if [ -z "$remote" ]; then echo "Please specify remote address"; return $EXIT_FAILURE; fi
    run ssh $remote sudo ufw status
    set_ssh_target_cache $remote
    return $?;
}

function remote_ufw_allow() {
    local remote=`get_ssh_target_cache $1`
    local ip=$2
    local port=$3
    if [ -z "$remote" ]; then echo "Please specify SSH address"; return $EXIT_FAILURE; fi
    if [ -z $ip ]; then ip=`get_current_ip`; fi
    if [ -z $port ]; then echo "Please specify port to allow"; return $EXIT_FAILURE; fi
    run ssh -n $remote sudo ufw allow from $ip to any port $port;
    set_ssh_target_cache $remote
    return $?;
}

function remote_ufw_delete_allow() {
    local remote=`get_ssh_target_cache $1`
    local ip=$2
    local port=$3
    if [ -z "$remote" ]; then echo "Please specify SSH address"; return; fi
    if [ -z $ip ]; then ip=`get_current_ip`; fi
    if [ -z $port ]; then echo "Please specify port to allow"; return; fi
    run ssh -n $remote sudo ufw delete allow from $ip to any port $port;
    set_ssh_target_cache $remote
    return $?;
}


### For RDP ###

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

alias us='ufw_status'
alias ua='ufw_allow_rdp'
alias ud='ufw_delete_allow_rdp'
alias rus='remote_ufw_status'
alias rua='remote_ufw_allow_rdp'
alias rud='remote_ufw_delete_allow_rdp'

alias xopen='xdg-open'

