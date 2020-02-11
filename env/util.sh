function registerPath() {
    if [ -z $1 ]; then
        echo "Error: failed to register PATH: path not specified"
        return
    fi
    if [ ! -d $1 ]; then
        echo "Error: failed to register $1 to PATH: path $1 not existed"
        return
    fi
    export PATH=$1:$PATH
}

function registerLibrary() {
    if [ -z $1 ]; then
        echo "Error: failed to register LD_LIBRARY_PATH: path not specified"
        return
    fi
    if [ ! -d $1 ]; then
        echo "Error: failed to register $1 to LD_LIBRARY_PATH: path $1 not existed"
        return
    fi
    export LD_LIBRARY_PATH=$1:$LD_LIBRARY_PATH
}

function registerPathAndLibrary {
    registerPath $1/bin
    registerLibrary $1/lib
}

function ufw_allow() {
    local ip=$1
    local port=$2
    sudo ufw allow from $ip to any port $port
}

function ufw_delete_allow() {
    local ip=$1
    local port=$2
    sudo ufw delete allow from $ip to any port $port
}

function get_current_ip() {
    curl -s https://ipinfo.io | python3 -c "import sys, json; print(json.load(sys.stdin)['ip'])"
}

function remote_ufw_status () {
    local remote=$1
    ssh $remote sudo ufw status
}

function remote_ufw_allow_rdp() {
    local remote=$1
    local ip=$2
    if [ -z $ip ]; then ip=`get_current_ip`; fi
    echo "ssh $remote sudo ufw allow from $ip to any port 3389"
    ssh $remote sudo ufw allow from $ip to any port 3389
}

function remote_ufw_delete_allow_rdp() {
    local remote=$1
    local ip=$2
    if [ -z $ip ]; then ip=`get_current_ip`; fi
    echo "ssh $remote sudo ufw delete allow from $ip to any port 3389"
    ssh $remote sudo ufw delete allow from $ip to any port 3389
}

export MY_GW_IP=$HOME/.cache/my-gw-ip

function rs () {
    local ip=
    local msg="Enter desired gateway IP => "
    if [ -n "$ZSH_VERSION" ]; then
        vared -p "$msg" ip
    else
        read -p "$msg" ip
    fi

    echo $ip > $MY_GW_IP
}
function ra () {
    local gwip=`cat $MY_GW_IP`
    local exists=`route -n | head -n 3 | grep $gwip`
    if [ -z "$exists" ]; then
        local cmd="sudo route add -net default gw $gwip metric 1"
        echo $cmd; eval $cmd;
    fi
    route -n | grep $gwip
}

function rc () {
    local gwip=`cat $MY_GW_IP`
    local cmd='sudo route del -net default gw $gwip metric 1'
    echo $cmd; eval $cmd;
    route -n
}

alias rn='route -n'
