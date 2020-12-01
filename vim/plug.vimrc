call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'vim-scripts/Rename2'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'jremmen/vim-ripgrep'

Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'mkitt/tabline.vim'

"Plug 'vim-scripts/cscope_macros.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 1

Plug 'vim-syntastic/syntastic'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
let g:vim_jsx_pretty_highlight_close_tag = 1
Plug 'alvan/vim-closetag'

Plug 'plasticboy/vim-markdown'
"Plug 'davidhalter/jedi-vim'
Plug 'tell-k/vim-autopep8'

Plug 'fatih/vim-go'
Plug 'rightson/vim-p4-syntax'


Plug 'vim-latex/vim-latex'
Plug 'junegunn/goyo.vim'

Plug 'sickill/vim-monokai'


" Initialize plugin system
call plug#end()
