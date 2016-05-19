" Scott Chen's VIM setting
syntax on

" Command mode
set history=512
set timeoutlen=250
set showcmd

"set autochdir

" File save/load
set autoread
set autowrite

" Clipboard
set clipboard=unnamed
set pastetoggle=<F7>

" Display
set number
set mouse=a
set ttymouse=xterm2
set background=dark
set ruler
set nowrap

" Enable folding
set foldenable
set foldopen=block,hor,mark,percent,quickfix,tag
set foldmethod=syntax
set foldcolumn=0
set foldlevel=99

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
au FileType c,c++,h,hpp set cindent autoindent smartindent
"au FileType python set noexpandtab

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
colo murphy
"colo pablo

if has("gui_running")
  set lines=120 columns=160
  "set vb
  "set guioptions-=T
  "set transparency=2
  "
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

"autocmd BufEnter * silent! lcd %:p:h
