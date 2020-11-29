# Launcher

function wsl_acroRd32() {
    local abspath=`realpath $1`
    local winpath=`wslpath -w $abspath`
    local bin=/mnt/c/Program\ Files\ \(x86\)/Adobe/Acrobat\ Reader\ DC/Reader/AcroRd32.exe
    "$bin" $winpath &
}

function wsl_terminator() {
    wsl_export_display
    terminator > /dev/null 2>&1 &
}
