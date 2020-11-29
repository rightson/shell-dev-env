# Display

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
