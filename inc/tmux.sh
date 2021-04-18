function tmux_rename_pane() {
    local title=$1
    printf '\033]2;%s\033\\' "$title"
}
