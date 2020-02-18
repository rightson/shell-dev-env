
export EXIT_SUCCESS=0
export EXIT_FAILURE=-1
export RDP_PORT=3389

function die() {
    echo $@
    exit $EXIT_FAILURE
}

function get_current_ip() {
    local temp=`mktemp`
    curl --insecure -s https://ipinfo.io > $temp
    if [ -s $temp ]; then
        cat $temp | python3 -c "import sys, json; print(json.load(sys.stdin)['ip'])"
    fi
    rm -f $temp
}

export MY_GW_IP=$HOME/.cache/my-gw-ip
export MY_RDP_CACHE=$HOME/.cache/my-rdp-cache
export CURRENT_IP=`get_current_ip`

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

function insert_unique_line_to_file () {
    local line=$1
    local file=$2
    if [ -n "$line" ]; then
        grep $line $file > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo $line >> $file
        fi
    fi
}

function remove_line_from_file () {
    local line=$1
    local file=$2
    if [ -n "$line" ]; then
        grep -v $line $file | tee $file > /dev/null
    fi
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

function get_rdp_cache() {
    local remote=$1
    if [ -n "$remote" ]; then
        echo $remote
        return
    fi
    if [ -z "$remote" ] && [ -s $MY_RDP_CACHE ]; then
        cat $MY_RDP_CACHE
        return
    fi
    die "Please specify SSH address"
}

function set_rdp_cache() {
    local remote=$1
    if [ -n "$remote" ]; then
        mkdir -p `dirname $MY_RDP_CACHE`
        echo $remote > $MY_RDP_CACHE;
    fi
}

function clean_rdp_cache() {
    echo "" > $MY_RDP_CACHE;
}

function remote_ufw_status() {
    local remote=`get_rdp_cache $1`
    if [ -z "$remote" ]; then echo "Please specify SSH address"; return; fi
    ssh $remote sudo ufw status
    set_rdp_cache $remote
}

function remote_ufw_allow_rdp() {
    local remote=`get_rdp_cache $1`
    local ip=$2
    if [ -z "$remote" ]; then echo "Please specify SSH address"; return; fi
    if [ -z $ip ]; then ip=`get_current_ip`; fi
    echo "ssh $remote sudo ufw allow from $ip to any port $RDP_PORT"
    ssh -n $remote sudo ufw allow from $ip to any port $RDP_PORT;
    set_rdp_cache $remote
}

function remote_ufw_delete_allow_rdp() {
    local remote=`get_rdp_cache $1`
    local ip=$2
    if [ -z "$remote" ]; then echo "Please specify SSH address"; return; fi
    if [ -z $ip ]; then ip=`get_current_ip`; fi
    echo "ssh $remote sudo ufw delete allow from $ip to any port $RDP_PORT"
    ssh -n $remote sudo ufw delete allow from $ip to any port $RDP_PORT;
    set_rdp_cache $remote
}

function is_gw_good () {
    route -n | head -n 3 | tail -n 1 | grep `cat $MY_GW_IP` > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo $EXIT_FAILURE
    else
        echo $EXIT_SUCCESS
    fi
}


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
