#!/bin/bash

IDENTIFIER='Added by shell-dev-env.'

BASHRC=$HOME/.bash_profile
if [ "`uname`" = "Linux" ]; then
    BASHRC=$HOME/.bashrc
fi
VIMRC=$HOME/.vimrc
SCREENRC=$HOME/.screenrc

if [ -z "`grep \"$IDENTIFIER\" $BASHRC`" ]; then
    cat rc/bashrc >> $BASHRC
fi

if [ -z "`grep \"$IDENTIFIER\" $VIMRC`" ]; then
    cat rc/vimrc >> $VIMRC
fi

if [ -z "`grep \"$IDENTIFIER\" $SCREENRC`" ]; then
    cat rc/screenrc >> $SCREENRC
fi
