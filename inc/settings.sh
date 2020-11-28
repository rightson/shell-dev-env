# Settings

export PATH=$HOME/local/bin:$HOME/.local/bin:$ENV_ROOT/bin:$PATH
if [ "NO_USER_LOCAL" != 1 ]; then
    export PATH=/usr/local/sbin:/usr/local/bin:$PATH
fi
export VIM_BIN=/usr/bin/vim
export EDITOR=$VIM_BIN
export SVN_EDITOR=$EDITOR
export VISUAL=$VIM_BIN
export GREP_COLOR="1;33"
export HISTCONTROL=ignoreboth
export TERM=xterm-256color
export LC_ALL=${LANG}
