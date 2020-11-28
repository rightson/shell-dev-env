# UFW

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

alias us='ufw_status'
alias ua='ufw_allow_rdp'
alias ud='ufw_delete_allow_rdp'

alias rus='remote_ufw_status'
alias rua='remote_ufw_allow_rdp'
alias rud='remote_ufw_delete_allow_rdp'
