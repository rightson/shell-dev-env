#!/bin/bash

function add_rdp_option() {
    export rdp_options="${rdp_options} $@"
}

function parse_rdp_options() {
    while (("$#")); do
        case $1 in
            --default)
                add_rdp_option +clipboard
                add_rdp_option +compression /compression-level:2
                add_rdp_option /sound
                shift;;
            --pretty)
                add_rdp_option +aero +menu-anims +fonts +wallpaper +themes +window-drag /rfx
                shift;;
            --hidpi)
                set_scale_ratio 180
                shift;;
            --async)
                add_rdp_option +async-input +async-update
                shift;;
            --set-scale)
                shift;
                local ratio=$1
                add_rdp_option /scale:$ratio /scale-desktop:$ratio /scale-device:$ratio
                shift;;
            --dry-run)
                local dry_run=1
                shift;;
            *)
                add_rdp_option $1
                shift;;
        esac
    done
}

function ask_credential() {
    if [ -z "$host" ]; then
        read -p "Host name: " host
    fi
    if [ -z "$user" ]; then
        read -p "User name: " user
    fi
    if [ -z "$password" ]; then
        read -sp "Password: " password
    fi
}

function start_my_rdp() {
    parse_rdp_options $@
    ask_credential
    local cmd="xfreerdp /v:$host /u:$user /p:$password $rdp_options"
    local prompt=`echo $cmd | sed "s/${password}/********/g"`
    echo $prompt;
    if [ "$dry_run" != "1" ]; then
        eval $cmd
    fi
}
