" Common VIM setting

set shell=/bin/bash

" Syntax
syntax on
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
au BufRead,BufNewFile *.tss set ft=css
au BufRead,BufNewFile {*.md,*.mkd,*.markdown} set ft=markdown
au BufRead,BufNewFile {COMMIT_EDITMSG}  set ft=gitcommit
au BufRead,BufNewFile *.tex Goyo
au BufRead,BufNewFile *.p4template set syntax=p4



" Command mode
set history=512
set timeoutlen=250
set showcmd
set wildmode=longest:list,full


" File save/load
set autoread
set autowrite


" Clipboard
set clipboard^=unnamed,unnamedplus
set pastetoggle=<F7>


" Display: basic
set number
set mouse=a
set vb t_vb=
set ttymouse=xterm2
set background=dark
set ruler
set nowrap
set linebreak


" Display: power line
set t_Co=256
let g:Powerline_symbols = 'unicode'


" Display: color schemes
colo PaperColor


" Display: folding
set foldenable
"set foldmethod=indent
setlocal foldmethod=syntax
set foldcolumn=0
set foldlevel=99
set foldopen=block,hor,mark,percent,quickfix,tag


" Display: indentation
set cindent autoindent smartindent
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
au BufNewFile,BufRead *.json set ft=javascript
au Filetype py,html,xml,htm,xsl set expandtab tabstop=4 shiftwidth=4 softtabstop=4
au FileType c,cpp,c++,h,hpp set cindent autoindent smartindent expandtab
au FileType GNUMakefile,Makefile,makefile,make,mk set noexpandtab


" Search
set incsearch hlsearch
set backspace=indent,eol,start
set noignorecase


" Editing: Auto-complete
set omnifunc=htmlcomplete#CompleteTags
set omnifunc=javascriptcomplete#CompleteJS
set omnifunc=pythoncomplete#Complete
set omnifunc=phpcomplete#CompletePHP
au FileType html,html set omnifunc=htmlcomplete#CompleteTags
au FileType javascript,json set omnifunc=javascriptcomplete#CompleteJS

au FileType txt,tex,md set wrap
au FileType txt,tex,md noremap <silent> k gk
au FileType txt,tex,md noremap <silent> j gj
au FileType txt,tex,md noremap <silent> $ g$

" Status bar
set laststatus=2

if !empty(expand(glob('cscope.out')))
    cs add cscope.out
endif

" Restore: cursor of last cursor position
autocmd BufReadPost *
            \ if line("'\"") > 0 && line ("'\"") <= line("$") |
            \ exe "normal g'\"" |
            \ endif


" Directory
"set autochdir
"autocmd BufEnter * silent! lcd %:p:h


" Directory: NERDTree
"autocmd BufWinEnter * if (exists(":NERDTree")) | NERDTreeFind | endif
"autocmd VimEnter * if (exists(":NERDTree")) | wincmd p | endif
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" GUI: appearance
if has("gui_running")
    set clipboard=unnamedplus
    "set lines=60 columns=120
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    "set transparency=2
    set linespace=2
    set guitablabel=%N:\ %M%t
    set noeb vb t_vb=

" GUI: default position
    autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
    autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif

