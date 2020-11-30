# FZF

function fzf_use_rg() {
    export FZF_CTRL_T_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!vendor/*" 2> /dev/null'
    export FZF_DEFAULT_COMMAND=$FZF_CTRL_T_COMMAND
}

function fzf_use_fd() {
    export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .node_modules'
    export FZF_DEFAULT_COMMAND=$FZF_CTRL_T_COMMAND
}
