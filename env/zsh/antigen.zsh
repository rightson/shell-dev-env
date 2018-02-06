ANTIGEN=~/.antigen.zsh
if [ ! -f $ANTIGEN ]; then
    curl -L git.io/antigen > $ANTIGEN
fi
source $ANTIGEN

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

antigen bundle git
antigen bundle npm
antigen bundle pip
antigen bundle colorize
if [ `uname -s` = Darwin ]; then
antigen theme apple
else
antigen theme robbyrussell
fi
antigen apply

