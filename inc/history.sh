# History Configuration

# Function to configure bash history settings
configure_bash_history() {
    # If in tmux, set separate history file for each pane
    if [ -n "$TMUX_PANE" ]; then
        export HISTFILE="$HOME/.bash_history_${TMUX_PANE#\%}"
    fi

    # Ensure history append mode (avoid overwriting)
    shopt -s histappend

    # History settings with larger default sizes
    export HISTSIZE=100000
    export HISTFILESIZE=200000
}

# Function to configure zsh history settings
configure_zsh_history() {
    # If in tmux, set separate history file for each pane
    if [[ -n "$TMUX_PANE" ]]; then
        export HISTFILE="$HOME/.zsh_history_${TMUX_PANE#\%}"
    fi

    # Disable shared history (avoid multi-shell sync)
    unsetopt share_history

    # Enable append history (ensure persistence)
    setopt APPEND_HISTORY

    # History settings with larger default sizes
    export HISTSIZE=100000
    export SAVEHIST=200000
}

# Auto-configure based on shell type
if [ -n "$BASH_VERSION" ]; then
    configure_bash_history
elif [ -n "$ZSH_VERSION" ]; then
    configure_zsh_history
fi