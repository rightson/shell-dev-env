" Scott Chen's VIM setting
syntax on

" Command mode
set history=512
set timeoutlen=250
set showcmd

set autochdir

" File save/load
set autoread
set autowrite

" Clipboard
set clipboard=unnamed
set pastetoggle=<F7>

" Display
set number
set mouse=a
set background=dark
set ruler
set nowrap
set foldenable
set foldmethod=marker
set foldlevel=100
set foldopen=block,hor,mark,percent,quickfix,tag
"set colorcolumn=80

" For power line
set t_Co=256
let g:Powerline_symbols = 'unicode'

" Indentation
"set cindent autoindent smartindent
set autoindent smartindent
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
au BufNewFile,BufRead *.json set ft=javascript
au Filetype html,xml,htm,xsl set expandtab tabstop=4 shiftwidth=4 softtabstop=4
au FileType make set noexpandtab
"au FileType python set noexpandtab

" Enable folding
set foldmethod=syntax
set foldcolumn=1
set foldlevel=99

" Search 
set incsearch hlsearch
set backspace=indent,eol,start

" Auto-complete
set omnifunc=htmlcomplete#CompleteTags
set omnifunc=javascriptcomplete#CompleteJS
set omnifunc=pythoncomplete#Complete
set omnifunc=phpcomplete#CompletePHP
au FileType html,html set omnifunc=htmlcomplete#CompleteTags
au FileType javascript,json set omnifunc=javascriptcomplete#CompleteJS

" Syntax
"au Filetype htm,html,xml,xsl source ~/.vim/scripts/closetag.vim 
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
au BufRead,BufNewFile *.tss set ft=css
au BufRead,BufNewFile {*.md,*.mkd,*.markdown} set ft=markdown
au BufRead,BufNewFile {COMMIT_EDITMSG}  set ft=gitcommit


" Status bar
set laststatus=2

" Jump to last cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \ exe "normal g'\"" |
\ endif

" function! RestoreSession()
"   if argc() == 0 "vim called without arguments
"     "execute 'source ~/session.vim'
"   end
" endfunction
" autocmd VimEnter * call RestoreSession()

" Color scheme
"colo torte
"colo slate
"colo koehler 
"colo murphy 
"colo pablo 

if has("gui_running")
    set lines=120 columns=160
    "set vb
    set guioptions-=T
    set transparency=2
    colo torte
endif

"let generate_tags = 1
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
    set cscopetag
  endif
endfunction
au BufEnter /* call LoadCscope()
autocmd BufEnter * silent! lcd %:p:h

