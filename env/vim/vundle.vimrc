" Vundle Simple Sample
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" status bar
"Plugin 'Lokaltog/vim-powerline'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" side bar
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
"Plugin 'tmhedberg/SimpylFold'

" window
Plugin 'maciej-ka/ZoomWin'

" editconfig
"Plugin 'editorconfig/editorconfig-vim'

" navgation/search
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'

" code tracer
Plugin 'vim-scripts/cscope_macros.vim'
Plugin 'vim-scripts/autoload_cscope.vim'
Plugin 'ludovicchabant/vim-gutentags'
"Plugin 'majutsushi/tagbar'

" editing"
Plugin 'Townk/vim-autoclose'
"Plugin 'ntpeters/vim-better-whitespace'

" JSON 
Plugin 'elzr/vim-json'

" session
"Plugin 'xolox/vim-session'
"Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-easytags'

" in-place file rename
Plugin 'vim-scripts/Rename2'

" JavaScript
Plugin 'othree/es.next.syntax.vim'
"Plugin 'othree/yajs.vim'
"Plugin 'moll/vim-node'
"Plugin 'jelera/vim-javascript-syntax'
"Plugin 'maksimr/vim-jsbeautify'

" Python
Plugin 'python.vim'

" Markdown
Plugin 'Markdown'

" Other plugins
"Plugin 'dkprice/vim-easygrep'
"Plugin 'easymotion/vim-easymotion'
"Plugin 'wincent/command-t.git'
"Plugin 'marijnh/tern_for_vim'
"Plugin 'eshion/vim-sftp-sync'
"Plugin 'eshion/vim-sync'
"Plugin 'vim-scripts/gtags.vim'
"Plugin 'vim-scripts/cscope.vim'
"Plugin 'vim-scripts/ctags.vim'
"Plugin 'vim-scripts/taglist.vim'
"Plugin 'http://github.com/gmarik/vim-visual-star-search.git'
"Plugin 'jQuery'
"Plugin 'tpope/vim-rails'
"Plugin 'clang-complete'
Plugin 'vim-latex/vim-latex'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set t_Co=256
"let g:Powerline_symbols = 'fancy'
let g:Powerline_symbols = 'unicode'

"let g:clang_library_path = '/usr/local/lib'

