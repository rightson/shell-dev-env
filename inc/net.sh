# Net

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

