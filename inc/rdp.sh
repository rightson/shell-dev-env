#!/bin/bash

function add_rdp_option() {
    export rdp_options="${rdp_options} $@"
}

function set_scale_ratio() {
    local ratio=$1
    add_rdp_option /scale:$ratio /scale-desktop:$ratio /scale-device:$ratio
}

function enable_compression() {
    add_rdp_option +compression /compression-level:2
}

function default_env() {
    add_rdp_option /sound
    add_rdp_option /f
    add_rdp_option /jpeg
    add_rdp_option /gdi:hw
    #add_rdp_option /sec:nla
    add_rdp_option +fonts
    add_rdp_option +clipboard
    add_rdp_option +bitmap-cache
    set_scale_ratio 100
}

function for_slow_env() {
    add_rdp_option -aero -menu-anims -wallpaper -themes -window-drag -decorations
}

function for_fast_env() {
    add_rdp_option +aero +menu-anims +wallpaper +themes +window-drag /rfx /video
}

function enable_cache() {
    add_rdp_option +gfx-small-cache +glyph-cache +offscreen-cache
}

function enable_async() {
    add_rdp_option +async-channels +async-input +async-update
}

function parse_rdp_options() {
    while (("$#")); do
        case $1 in
            --default)
                default_env
                shift;;
            --fast|--pretty)
                for_fast_env
                shift;;
            --slow)
                for_slow_env
                shift;;
            --cache)
                enable_cache
                shift;;
            --async)
                enable_async
                shift;;
            --hidpi)
                set_scale_ratio 180
                shift;;
            --set-scale)
                shift;
                set_scale_ratio $1
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
