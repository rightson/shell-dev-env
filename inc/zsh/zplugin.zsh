### Added by Zplugin's installer
source '/home/rightson/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

zplugin load zdharma/history-search-multi-word

zplugin ice compile"*.lzui"
zplugin load zdharma/zui

# Binary release in archive, from Github-releases page; after automatic unpacking it provides command "fzf"

zplugin ice from"gh-r" as"program"; zplugin load junegunn/fzf-bin

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# Used also `bpick' which selects Linux packages – in this case not needed, Zplugin
# automatically narrows down the releases by grepping uname etc.

zplugin ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"; zplugin load docker/compose

# Vim repository on Github – a source that needs compilation

zplugin ice as"program" atclone"rm -f src/auto/config.cache; ./configure" atpull"%atclone" make pick"src/vim"; zplugin light vim/vim

# Scripts that are built at install (there's single default make target, "install", and
# it constructs scripts by cat-ting a few files). The make ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be default target

zplugin ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zplugin light tj/git-extras

zplugin light zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-syntax-highlighting

# Load the pure theme, with zsh-async that's bundled with it
zplugin ice pick"async.zsh" src"pure.zsh";
zplugin light sindresorhus/pure

