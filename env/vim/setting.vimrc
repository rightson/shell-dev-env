" Scott Chen's VIM setting
" Syntax
syntax on
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
au BufRead,BufNewFile *.tss set ft=css
au BufRead,BufNewFile {*.md,*.mkd,*.markdown} set ft=markdown
au BufRead,BufNewFile {COMMIT_EDITMSG}  set ft=gitcommit


" Command mode
set history=512
set timeoutlen=250
set showcmd
set wildmode=longest:list,full


" File save/load
set autoread
set autowrite


" Clipboard
set clipboard=unnamedplus
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
set colorcolumn=120
let &colorcolumn=join(range(120,999),",")
highlight ColorColumn ctermbg=235 guibg=#2c2d27
set fillchars+=vert:\ 

" Display: power line
set t_Co=256
let g:Powerline_symbols = 'unicode'


" Display: color schemes
" colo torte
" colo slate
" colo koehler
" colo murphy
" colo pablo
" colo monokai


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
au Filetype html,xml,htm,xsl set expandtab tabstop=4 shiftwidth=4 softtabstop=4
au FileType c,cpp,c++,h,hpp set cindent autoindent smartindent expandtab
au FileType GNUMakefile,Makefile,makefile,make,mk set noexpandtab


" Search
set incsearch hlsearch
set backspace=indent,eol,start


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


" Restore: cursor of last cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \ exe "normal g'\"" |
\ endif

" Restore: entire session
function! RestoreSession()
  if argc() == 0 "vim called without arguments
    execute 'source ~/session.vim'
  end
endfunction
" autocmd VimEnter * call RestoreSession()


" Directory
"set autochdir
"autocmd BufEnter * silent! lcd %:p:h


" Directory: NERDTree
"autocmd BufWinEnter * if (exists(":NERDTree")) | NERDTreeFind | endif
"autocmd VimEnter * if (exists(":NERDTree")) | wincmd p | endif
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" Tags: ctags/cscope generation
"function! DelTagOfFile(file)
"  let fullpath = a:file
"  let cwd = getcwd()
"  let tagfilename = cwd . "/tags"
"  let f = substitute(fullpath, cwd . "/", "", "")
"  let f = escape(f, './')
"  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
"  let resp = system(cmd)
"endfunction
"
"function! UpdateTags()
"  let f = expand("%:p")
"  let cwd = getcwd()
"  let tagfilename = cwd . "/tags"
"  let cmd = 'ctags -a -f ' . tagfilename . ' --c++-kinds=+p --fields=+iaS --extra=+q ' . '"' . f . '"'
"  call DelTagOfFile(f)
"  let resp = system(cmd)
"  let cmd = "find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' -o -iname '*.js' -o -iname '*.py' > cscope.files"
"  let resp = system(cmd)
"  let cmd = "cscope -b -i cscope.files -f cscope.out"
"  let resp = system(cmd)
"  cs reset
"endfunction
"autocmd BufWritePost,BufReadPost *.cpp,*.hpp,*.h,*.c silent! call UpdateTags()


" Auto track session during editing
" autocmd BufWritePost * execute ':mksession! Session.vim'
" autocmd BufWinEnter * execute ':mksession! Session.vim'
" autocmd BufWinLeave * execute '!\rm -f Session.vim'


" GUI: appearance
if has("gui_running")
  set lines=60 columns=120
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L
  "set transparency=2
  colo PaperColor
  set linespace=2
  set guitablabel=%N:\ %M%t
  set noeb vb t_vb=
endif


" GUI: default position
if has("gui_running")
  " restore screen size and position
  function! ScreenFilename()
    if has('amiga')
      return "s:.vimsize"
    elseif has('win32')
      return $HOME.'\_vimsize'
    else
      return $HOME.'/.vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let f = ScreenFilename()
    if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    if has("gui_running") && g:screen_size_restore_pos
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx()<0?0:getwinposx()) . ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
  autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif

