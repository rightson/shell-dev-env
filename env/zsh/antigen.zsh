ANTIGEN=~/.antigen.zsh
if [ ! -f $ANTIGEN ]; then
    curl -L git.io/antigen > $ANTIGEN
fi

if [ -z `command -v antigen` ]; then
    source $ANTIGEN
    antigen use oh-my-zsh

    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle zsh-users/zsh-completions
    antigen bundle zsh-users/zsh-autosuggestions

    antigen bundle git
    antigen bundle npm
    antigen bundle pip
    antigen bundle colorize
    antigen bundle docker

    if [ `uname -s` = Darwin ]; then
        antigen theme apple
    else
        antigen theme bira
    fi
    antigen apply
fi
