# Display


function wsl2_export_display() {
    display=$(route -n | grep -E '^0.0.0.0' | head -n 1 | awk '{print $2}')
    export DISPLAY=$display:0
}

function wsl_export_display() {
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
}

function set_hidpi_scale () {
    local scale=$1
    if [ "$scale" = "" ]; then
        scale=2
    fi
    export QT_SCALE_FACTOR=$scale
    export GDK_SCALE=$scale
}

function get_hidpi_scale () {
    echo $QT_SCALE_FACTOR
    echo $GDK_SCALE
}
