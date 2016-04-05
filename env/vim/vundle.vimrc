" Vundle Simple Sample
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" status bar
Plugin 'Lokaltog/vim-powerline'

" side bar
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'tmhedberg/SimpylFold'

" navgation/search
Plugin 'scrooloose/nerdtree'

" code tracer
Plugin 'vim-scripts/cscope_macros.vim'
Plugin 'vim-scripts/autoload_cscope.vim'
Plugin 'majutsushi/tagbar'

" session
Plugin 'xolox/vim-session'
Plugin 'xolox/vim-misc'

" in-place file rename
Plugin 'vim-scripts/Rename2'

" JavaScript
Plugin 'othree/es.next.syntax.vim'
Plugin 'othree/yajs.vim'
Plugin 'moll/vim-node'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'maksimr/vim-jsbeautify'

" Python
Plugin 'python.vim'

" Markdown
Plugin 'Markdown'

" Other plugins
"Plugin 'easymotion/vim-easymotion'
"Plugin 'wincent/command-t.git'
"Plugin 'marijnh/tern_for_vim'
"Plugin 'eshion/vim-sftp-sync'
"Plugin 'eshion/vim-sync'
"Plugin 'dkprice/vim-easygrep'
"Plugin 'xolox/vim-easytags'
"Plugin 'vim-scripts/gtags.vim'
"Plugin 'vim-scripts/simple-pairs'
"Plugin 'vim-scripts/cscope.vim'
"Plugin 'vim-scripts/ctags.vim'
"Plugin 'vim-scripts/taglist.vim'
"Plugin 'http://github.com/gmarik/vim-visual-star-search.git'
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

