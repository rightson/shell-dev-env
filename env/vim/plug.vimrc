call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-obsession'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/cscope_macros.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'jremmen/vim-ripgrep'
Plug 'easymotion/vim-easymotion'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'airblade/vim-gitgutter'
Plug 'mkitt/tabline.vim'
Plug 'vim-scripts/Rename2'

"Plug 'elzr/vim-json'
"Plug 'othree/es.next.syntax.vim'
Plug 'pangloss/vim-javascript'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
let g:vim_jsx_pretty_highlight_close_tag = 1
Plug 'alvan/vim-closetag'

Plug 'plasticboy/vim-markdown'
"Plug 'davidhalter/jedi-vim'
Plug 'tell-k/vim-autopep8'

Plug 'vim-latex/vim-latex'
Plug 'junegunn/goyo.vim'

"Plug 'fatih/vim-go'
"
Plug 'rightson/vim-p4-syntax'

Plug 'sickill/vim-monokai'
"Plug 'trusktr/seti.vim'
"Plug 'NLKNguyen/papercolor-theme'
"Plug 'morhetz/gruvbox'
"Plug 'chriskempson/base16-vim'
"Plug 'dracula/dracula-theme'

" Unmanaged plugin (manually installed and updated)


" Initialize plugin system
call plug#end()
