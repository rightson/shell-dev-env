#!/bin/bash
# extension for ~/.bashrc


# Only source custom setting when in an interactive session
[ -z "$PS1" ] && return


# Export global variables
export ENV_PATH=$HOME/.env
export PATH=/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
export PATH=$ENV_PATH/bin:$PATH
export VIM_BIN=/usr/bin/vim
export EDITOR=$VIM_BIN
export SVN_EDITOR=$EDITOR
export VISUAL=$VIM_BIN
export GREP_COLOR="1;33"
export HISTCONTROL=ignoreboth
export TERM=xterm-256color

