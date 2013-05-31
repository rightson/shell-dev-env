" Vundle Simple Sample

set nocompatible               " be iMproved
syntax on
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required! 
Bundle 'gmarik/vundle'


" Vim Repos
Bundle 'vim-scripts/gtags.vim'
"Bundle 'vim-scripts/simple-pairs'
"Bundle 'vim-scripts/cscope.vim'
"Bundle 'vim-scripts/ctags.vim'
"Bundle 'vim-scripts/taglist.vim'


" Other Repos 
Bundle "Lokaltog/vim-powerline"
Bundle 'git://git.wincent.com/command-t.git'
"Bundle 'scrooloose/nerdtree'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'http://github.com/gmarik/vim-visual-star-search.git'
"Bundle 'Markdown'
"Bundle 'pyflakes.vim'
"Bundle 'python.vim'
"Bundle 'jQuery'
"Bundle 'tpope/vim-rails'
"Bundle 'clang-complete'
"Bundle 'airblade/vim-gitgutter'


" Settings
filetype plugin indent on     " required!

set t_Co=256
"let g:Powerline_symbols = 'fancy'
let g:Powerline_symbols = 'unicode'

"let g:clang_library_path = '/usr/local/lib'

