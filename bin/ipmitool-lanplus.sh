#!/bin/bash

HOST_CACHE=~/.wrapper-cache
USER=
PASSWD=

usage() {
    echo "Usage: `basename $0` <IP> <Command/Data...>"
    echo "  Once you have assigned IP, then you can skip <IP> parameter as below:"
    echo "       `basename $0` <Command/Data...>"
    echo "       `basename $0` OPTIONS"
    echo ""
    echo "Options:"
    echo "      clearcache  - remove IP cache"
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

if [ -z $USER ] || [ -z $PASSWD ]; then
    echo 'Please config USER/PASSWD in this script!'
    exit
fi

if [ "$1" = 'clearcache' ]; then
    execho rm -f $HOST_CACHE
    exit
fi

if [ `valid_ip $1` -eq 0 ]; then
    HOST=$1
    echo $host > $HOST_CACHE
    shift
else
    if [ -r $HOST_CACHE ]; then
        HOST=`cat $HOST_CACHE`
    else
        usage
    fi
fi

execho ipmitool -I lanplus -U $USER -P $PASSWD -H $HOST $@