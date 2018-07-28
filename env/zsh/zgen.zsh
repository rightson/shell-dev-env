ZGEN=${HOME}/.zgen/zgen.zsh
if [ ! -f ${ZGEN} ]; then
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

source ${ZGEN}

if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-autosuggestions

    # bulk load
    zgen loadall <<EOPLUGINS
        zsh-users/zsh-history-substring-search
EOPLUGINS
    # ^ can't indent this EOPLUGINS

    # theme
    #zgen oh-my-zsh themes/arrow
    zgen oh-my-zsh themes/candy

    # save all to init script
    zgen save
fi
