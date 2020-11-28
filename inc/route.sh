# Route

export MY_METRIC=100
export MY_GW_IP_CACHE=$HOME/.cache/my-gw-ip

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

