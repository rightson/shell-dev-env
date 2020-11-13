#!/bin/bash
# extension for ~/.bashrc


# Only source custom setting when in an interactive session
[ -z "$PS1" ] && return


# Export global variables
export ENV_ROOT=$HOME/.env
export PATH=$HOME/local/bin:$HOME/.local/bin:$ENV_ROOT/bin:$PATH
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export VIM_BIN=/usr/bin/vim
export EDITOR=$VIM_BIN
export SVN_EDITOR=$EDITOR
export VISUAL=$VIM_BIN
export GREP_COLOR="1;33"
export HISTCONTROL=ignoreboth
export TERM=xterm-256color
export LC_ALL=${LANG}
