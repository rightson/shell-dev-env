#!/bin/bash

HOST_CACHE=~/.wrapper-cache

usage() {
    echo "Usage: `basename $0` [IP] <Command/Data...>"
    exit
}

execho() {
    echo $@
    $@
}

valid_ip()
{
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        ping -c 1 -W 1 $ip 2>&1 > /dev/null
        echo 0
    else
        echo 1
    fi
}

if [ `valid_ip $1` -eq 0 ]; then
    host=$1
    echo $host > $HOST_CACHE
    shift
else
    if [ -r $HOST_CACHE ]; then
        host=`cat $HOST_CACHE`
    else
        usage
    fi
fi
