# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/rightson/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

vimode() {
    bindkey -v
    bindkey '^P' up-history
    bindkey '^N' down-history
    bindkey '^A' vi-beginning-of-line
    bindkey '^E' vi-end-of-line
    bindkey '^U' kill-whole-line
}
vimode
