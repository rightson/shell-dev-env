#!/bin/sh
# author: Scott Chen

usage()
{
    echo "Kermit Easy Command"
    echo ""
    echo "Usage:"
    echo "  `basename $0` help"
    echo "  `basename $0` example"
    echo "  `basename $0` <tty-device> <speed>"
    echo "  `basename $0` ls|list"
    echo "  `basename $0` -d <tty-device>"
    echo "  `basename $0` -s <tty-device>"
    echo "  `basename $0` tell <user> <messages...>"
    echo ""
    if [ "$1" = 'verbose' ]; then
        echo "Example:"
        echo "  `basename $0` ttyS0 115200  --> connect to /dev/ttyS0, speed=115200"
        echo "  `basename $0` ttyS0         --> connect to /dev/ttyS0, speed=115200"
        echo "  `basename $0` ttyUSB1 9600  --> connect to /dev/ttyUSB1, speed=9600"
        echo "  `basename $0` 2 9600        --> connect to /dev/ttyUSB2, speed=9600"
        echo "  `basename $0` 2             --> connect to /dev/ttyUSB2, speed=115200"
        echo "  `basename $0` ls            --> show kermit connections and lock files"
        echo "  `basename $0` -d ttyUSB0    --> terminate connection to /dev/ttyUSB0"
        echo "  `basename $0` -d 1          --> terminate connection to /dev/ttyUSB1"
        echo "  `basename $0` tell scott hi --> send a message "hi" to scott in all tty"
        echo ""
    fi
    exit 
}

gen_kermitrc()
{
    local tty=$1
    local speed=$2
    echo "  set line /dev/$1"
    echo "  set speed $speed"
    echo "  set carrier-watch off"
    echo "  set flow-control none"
    echo "  log session ~/km.log"
    echo "  connect"
}

run_km()
{
    rcfile=/tmp/$USER-$1-$2
    gen_kermitrc $1 $2 > $rcfile
    echo "kermit -y $rcfile"
    cat $rcfile
    kermit -y $rcfile && rm -f $rcfile
}

kermit_mode()
{
    local tty=$1
    local speed=$2
    if [ ! -r "/dev/$tty" ]; then
        if [ ! -r "/dev/ttyUSB$tty" ]; then
            echo "Device '$tty' doesn't exist!"
            exit
        fi
    fi
    if [ $# -lt 1 ]; then
        list_mode
        exit
    fi
    
    if [ "$1" -eq $1 2>/dev/null ]; then
        tty=ttyUSB$1
    else
        tty=$1
    fi
    
    if [ -z "$2" ]; then
        speed=115200
    fi
    if [ -n "`ps aux | grep kermit | grep $tty`" ]; then
        printf "Device /dev/$tty is locked.\n"
        exit
    fi
    run_km $tty $speed
}

list_km_info()
{
    ps aux | grep kermit | grep -v grep | grep -v defunc | \
        sed -e 's/\/tmp\/[a-zA-Z0-9]\+-\([a-zA-Z0-9]\+\)-[0-9]\+/\1/g' | \
        awk '{ printf "%-10s | %-10s | %-10s | km -d %-15s\n\r", $(NF), $1, $2, $(NF)}'
}

list_mode()
{
    echo -ne "-----------+------------+------------+------------------\n\r" 
    echo -ne " TTY       | User       | Pid        | Release command  \n\r" 
    echo -ne "-----------+------------+------------+------------------\n\r" 
    list_km_info
    echo -ne "-----------+------------+------------+------------------\n\r" 
}

delete_mode()
{
    local key=$2
    if [ "$key" -eq $key 2> /dev/null ]; then
        key=ttyUSB$2
    fi
    local lockfile="/var/lock/LCK..$key"
    if [ -f $lockfile ]; then
        pid=`list_km_info | grep $key | awk -F "|" '{print $3}'`
        victim=`list_km_info | grep $key | awk -F "|" '{print $2}'`
        send_messages tell $victim "Your $key was stolen"
        echo -ne "Terminating $key (PID=`echo $pid`)\n\r"
        sudo kill -9 $pid 2> /dev/null
        sudo rm -f $lockfile 2> /dev/null
    fi
}

get_available_users()
{
    who | grep -v USER | awk '{ print $1}' | sort | uniq | awk '{ printf "%s ", $1}'
}

check_user()
{
    local user=$1
    export valid=n
    for guy in `get_available_users`; do
        if [ $guy = $user ]; then
            valid=y
        fi
    done
    if [ $valid = n ]; then
        echo "User '$user' is not available, send to one of below instead: "
        echo "  `get_available_users`"
        echo ""
        exit
    fi
}

send_messages()
{
    export from=`whoami`
    shift
    export user=$1
    shift
    export msg=$@
    check_user $user
    w | grep "$user" | awk '{ printf "echo \$from said: \$msg | write \$user %s\n", $2}' 2>/dev/null | sh 
    echo "To:       $user"
    echo "Messages: $msg"
    echo "Status:   Sent!"
    unset msg
    unset from
    unset user
}

tell_mode()
{
    if [ $# -lt 1 ]; then
        echo ""
        echo "Usage: `basename $0` tell <user> <messages...>"
        echo ""
        echo "user:"
        echo "  `get_available_users`"
        return
    fi
    send_messages $@
}

steal_mode()
{
    delete_mode $@
    echo -e "Don't be evil!\n\r"
    sleep 1
    echo -e "Stealing tty... haha...\n\r"
    sleep 2
    shift
    kermit_mode $@
}

case $1 in
    help|-h|--help)
        usage
    ;;
    example)
        usage verbose
    ;;
    list|ls)
        list_mode $@
    ;;
    delete|release|-d)
        delete_mode $@
        list_mode $@
    ;;
    steal|-s)
        steal_mode $@
    ;;
    tell)
        tell_mode $@
    ;;
    *)
        kermit_mode $@
    ;;
esac

