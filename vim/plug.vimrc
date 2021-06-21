call plug#begin('~/.vim/plugged')

Plug 'vim-scripts/Rename2'

if v:version < 800
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
else
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
endif

Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'airblade/vim-gitgutter'
"Plug 'vim-scripts/cscope_macros.vim'
Plug 'editorconfig/editorconfig-vim'
"Plug 'Yggdroot/indentLine'

"Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
let g:vim_jsx_pretty_highlight_close_tag = 1

Plug 'plasticboy/vim-markdown'
Plug 'tell-k/vim-autopep8'

if v:version >= 801
Plug 'fatih/vim-go'
endif

Plug 'sickill/vim-monokai'

if filereadable($HOME."/.vimrc.plug")
    " Put your local plug here
    source $HOME/.vimrc.plug
endif

" Initialize plugin system
call plug#end()
