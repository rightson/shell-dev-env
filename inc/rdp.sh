#!/bin/bash

if [[ $_ == $0 ]]; then
    read -p "Host name: " host
    read -p "User name: " user
    read -sp "Password: " password
fi

if [ -z "$option_basic" ]; then
    export option_basic="+clipboard"
else
    export option_basic="+clipboard $option_basic"
fi

if [ -z "$scale_ratio" ]; then
    export scale_ratio=180
fi

if [ -z "$option_display" ]; then
    export option_display="/dynamic-resolution /scale:$scale_ratio /scale-desktop:$scale_ratio /scale-device:$scale_ratio +fonts"
    #export option_display="/scale:$scale_ratio /scale-desktop:$scale_ratio /scale-device:$scale_ratio +fonts"
fi
if [ -z "$option_sound" ]; then
    export option_sound="/sound"
fi
if [ -z "$option_async" ]; then
    #export option_async="+async-input +async-update"
    #export option_async="+async-update"
    export option_async=""
fi
if [ -z "$option_lowbw" ]; then
    export option_lowbw="$option_async -wallpaper -themes +compression /compression-level:2"
fi

function start_my_rdp() {
    local options="$option_user $option_basic $option_display $option_lowbw $option_sound"
    unset option_user option_basic option_display option_lowbw option_sound
    local cmd="xfreerdp /v:$host /u:$user /p:$password $options $*"
    local cmd_prompt=`echo $cmd | sed "s/${password}/********/g"`
    local prefix=/tmp/xfreerdp.$USER.$host
    local my_rdp_pid_file=$prefix.pid

    set -m
    echo $cmd_prompt;
    $cmd &
    echo $! > $my_rdp_pid_file
    echo "pid=`cat $my_rdp_pid_file` ($my_rdp_pid_file)"
    fg > /dev/null
    rm $my_rdp_pid_file
}
