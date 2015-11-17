" Vundle Simple Sample
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'Lokaltog/vim-powerline'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'easymotion/vim-easymotion'
Plugin 'dyng/ctrlsf.vim'

Plugin 'wincent/command-t.git'
Plugin 'tpope/vim-fugitive'

Plugin 'moll/vim-node'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'othree/yajs.vim'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'marijnh/tern_for_vim'
Plugin 'majutsushi/tagbar'
Plugin 'vim-scripts/Rename2'
Plugin 'Markdown'

Plugin 'eshion/vim-sftp-sync'
Plugin 'eshion/vim-sync'
Plugin 'dkprice/vim-easygrep'
Plugin 'xolox/vim-easytags'
Plugin 'xolox/vim-misc'

Plugin 'tmhedberg/SimpylFold'

"Plugin 'vim-scripts/gtags.vim'
"Plugin 'vim-scripts/simple-pairs'
"Plugin 'vim-scripts/cscope.vim'
"Plugin 'vim-scripts/ctags.vim'
"Plugin 'vim-scripts/taglist.vim'

"Plugin 'tpope/vim-fugitive'
"Plugin 'http://github.com/gmarik/vim-visual-star-search.git'
"Plugin 'pyflakes.vim'
"Plugin 'python.vim'
"Plugin 'jQuery'
"Plugin 'tpope/vim-rails'
"Plugin 'clang-complete'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set t_Co=256
"let g:Powerline_symbols = 'fancy'
let g:Powerline_symbols = 'unicode'

"let g:clang_library_path = '/usr/local/lib'

