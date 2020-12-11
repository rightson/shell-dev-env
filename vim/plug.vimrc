call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'vim-scripts/Rename2'

if v:version < 800
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
else
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
endif
Plug 'jremmen/vim-ripgrep'

Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'mkitt/tabline.vim'

"Plug 'vim-scripts/cscope_macros.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'Yggdroot/indentLine'

Plug 'vim-syntastic/syntastic'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
let g:vim_jsx_pretty_highlight_close_tag = 1
Plug 'alvan/vim-closetag'

Plug 'plasticboy/vim-markdown'
"Plug 'davidhalter/jedi-vim'
Plug 'tell-k/vim-autopep8'

Plug 'fatih/vim-go'
let  g:go_version_warning = 0
Plug 'rightson/vim-p4-syntax'


Plug 'vim-latex/vim-latex'
Plug 'junegunn/goyo.vim'

Plug 'sickill/vim-monokai'


" Initialize plugin system
call plug#end()
