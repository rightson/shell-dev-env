" Vundle Simple Sample

set nocompatible               " be iMproved
syntax on
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

 " let Vundle manage Vundle
 " required! 
 Bundle 'gmarik/vundle'

 " My Bundles here:
 "
 " original repos on github
 Bundle 'tpope/vim-fugitive'
 Bundle 'Lokaltog/vim-easymotion'
 Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
 Bundle 'tpope/vim-rails.git'
 " vim-scripts repos
 Bundle 'L9'
 Bundle 'FuzzyFinder'
 " non github repos
 Bundle 'git://git.wincent.com/command-t.git'


" Appearance
Bundle "Lokaltog/vim-powerline"


" Navigation
Bundle 'scrooloose/nerdtree'
Bundle 'http://github.com/gmarik/vim-visual-star-search.git'
Bundle 'Lokaltog/vim-easymotion'

" Syntax related
"Bundle "Markdown"
"Bundle 'pyflakes.vim'
"Bundle 'python.vim'
"Bundle "jQuery"
"Bundle 'tpope/vim-rails'
"Bundle 'clang-complete'
"Bundle 'vim-scripts/simple-pairs'


" Code browsing
"Bundle 'vim-scripts/cscope.vim'
"Bundle 'vim-scripts/ctags.vim'
Bundle 'vim-scripts/gtags.vim'
Bundle 'vim-scripts/taglist.vim'

filetype plugin indent on     " required!


" Settings

" For Powerline
set t_Co=256
let g:Powerline_symbols = 'fancy'
let g:Powerline_symbols = 'unicode'

" For CLang
"let g:clang_library_path = '/usr/local/lib'

