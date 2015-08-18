" Vundle Simple Sample
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'Lokaltog/vim-powerline'

"Plugin 'vim-scripts/gtags.vim'
"Plugin 'vim-scripts/simple-pairs'
"Plugin 'vim-scripts/cscope.vim'
"Plugin 'vim-scripts/ctags.vim'
"Plugin 'vim-scripts/taglist.vim'

"Plugin 'tpope/vim-fugitive'
"Plugin 'git://git.wincent.com/command-t.git'
"Plugin 'scrooloose/nerdtree'
"Plugin 'Lokaltog/vim-easymotion'
"Plugin 'http://github.com/gmarik/vim-visual-star-search.git'
"Plugin 'Markdown'
"Plugin 'pyflakes.vim'
"Plugin 'python.vim'
"Plugin 'jQuery'
"Plugin 'tpope/vim-rails'
"Plugin 'clang-complete'
"Plugin 'airblade/vim-gitgutter'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set t_Co=256
"let g:Powerline_symbols = 'fancy'
let g:Powerline_symbols = 'unicode'

"let g:clang_library_path = '/usr/local/lib'

