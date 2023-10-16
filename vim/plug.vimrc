call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " use <tab> to trigger completion and navigate to the next complete item
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

if v:version < 800
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
else
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
endif

if v:version >= 800
    Plug 'skywind3000/asyncrun.vim'
endif

" if v:version >= 801
"     Plug 'fatih/vim-go'
" endif


Plug 'vim-scripts/Rename2'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#tab_nr_type = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail'

"Plug 'airblade/vim-gitgutter'
"Plug 'vim-scripts/cscope_macros.vim'
    set cscopetag
    set csto=1

Plug 'editorconfig/editorconfig-vim'
"Plug 'Yggdroot/indentLine'

"Plug 'preservim/tagbar'

"Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
    let g:vim_jsx_pretty_highlight_close_tag = 1

Plug 'plasticboy/vim-markdown'
Plug 'tell-k/vim-autopep8'

"Plug 'ludovicchabant/vim-gutentags'
"Plug 'skywind3000/gutentags_plus'
"Plug 'vim-scripts/ZoomWin'
"Plug 'tpope/vim-obsession'

Plug 'sickill/vim-monokai'
Plug 'NLKNguyen/papercolor-theme'

"Plug 'alvan/vim-closetag'
"    let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
"    let g:closetag_xhtml_filetypes = 'xhtml,jsx'
"    let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx"

if filereadable($HOME."/.vimrc.plug")
    " Put your local plug here
    source $HOME/.vimrc.plug
endif

" Initialize plugin system
call plug#end()
