#!/bin/bash
# extension for ~/.bashrc


# Only source custom setting when in an interactive session
[ -z "$PS1" ] && return


# Export global variables
export PATH=/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
export PATH=~/.shell-dev-env/bin:$PATH
#export PATH=/usr/local/share/python:$PATH
#export PATH=/usr/local/Cellar/ruby/1.9.3-p374/bin:$PATH
export VIM_BIN=/usr/bin/vim
export EDITOR=$VIM_BIN
export SVN_EDITOR=$EDITOR
export VISUAL=$VIM_BIN
export GREP_COLOR="1;33"
export HISTCONTROL=ignoreboth
export TERM=xterm

