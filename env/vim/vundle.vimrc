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

if has("gui_running")
Plugin 'Lokaltog/vim-powerline'
endif

Plugin 'wincent/command-t.git'
Plugin 'easymotion/vim-easymotion'
Plugin 'scrooloose/nerdtree'

Plugin 'eshion/vim-sftp-sync'
Plugin 'eshion/vim-sync'

Plugin 'moll/vim-node'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'marijnh/tern_for_vim'

"Plugin 'vim-scripts/gtags.vim'
"Plugin 'vim-scripts/simple-pairs'
"Plugin 'vim-scripts/cscope.vim'
"Plugin 'vim-scripts/ctags.vim'
"Plugin 'vim-scripts/taglist.vim'

"Plugin 'tpope/vim-fugitive'
"Plugin 'http://github.com/gmarik/vim-visual-star-search.git'
Plugin 'Markdown'
"Plugin 'pyflakes.vim'
"Plugin 'python.vim'
"Plugin 'jQuery'
"Plugin 'tpope/vim-rails'
"Plugin 'clang-complete'
Plugin 'airblade/vim-gitgutter'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set t_Co=256
"let g:Powerline_symbols = 'fancy'
let g:Powerline_symbols = 'unicode'

"let g:clang_library_path = '/usr/local/lib'

