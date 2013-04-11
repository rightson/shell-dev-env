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
" ...

" Powerline
Bundle "Lokaltog/vim-powerline"

" Nerdtree
Bundle 'scrooloose/nerdtree'

" Command-t
Bundle 'wincent/Command-T'

" Syntax highlight
Bundle "Markdown"

" Python
Bundle 'pyflakes.vim'
"Bundle 'python.vim'

" EasyMotion
Bundle 'Lokaltog/vim-easymotion'

" Vim-snipmate
" dependency
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/snipmate-snippets"
" main plugin
Bundle "garbas/vim-snipmate"

" CLang
Bundle 'clang-complete'

" Programming
Bundle "jQuery"
Bundle 'tpope/vim-rails'

" python-mode
" Bundle 'klen/python-mode'

" Simple pairs
Bundle 'vim-scripts/simple-pairs'

" Navigation
Bundle "http://github.com/gmarik/vim-visual-star-search.git"

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

" For Powerline
set t_Co=256
let g:Powerline_symbols = 'fancy'
" let g:Powerline_symbols = 'unicode'

" For CLang
"let g:clang_library_path = '/usr/local/lib'

