" vim hotkeys

noremap <F2> :qa<CR>

noremap <F3> :cs find s <C-R>=expand("<cword>")<CR><CR>

noremap <F5> :source ~/.vimrc<CR>

noremap <F6> :NERDTreeToggle<CR>

noremap <F8> :ZoomWin<CR>

noremap <F9> :if &mouse == 'a' \| set mouse= \| else \| set mouse=a \| endif<CR><CR>

noremap <F10> :%!xxd

noremap <S-F11> :Goyo<CR>:source ~/.vimrc<CR>
noremap <F12> :set nu!<CR>

noremap <C-G> <Esc>:echo expand('%:p')<Return>

" search and replace
nnoremap <Leader><Leader>r :%s/\<<C-r><C-w>\>/

" strip space
noremap <C-k>t :%s/\s\+$//g<CR>

" sidebar toggle (sublime style
noremap <C-k>b :NERDTreeToggle %<CR>
noremap <C-k>f :NERDTreeFind %<CR>

noremap <C-k>r :!ctags -R .<CR>:!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' -o -iname '*.js' -o -iname '*.py' > cscope.files<CR> :!cscope -b -i cscope.files -f cscope.out<CR>:cs reset<CR>

" autopep8
noremap <C-a>8 :Autopep8<CR>

" tab
nmap <C-w>t :tabnew %<CR>
if has("gui_running")
    :noremap <A-1> 1gt<CR>
    :noremap <A-2> 2gt<CR>
    :noremap <A-3> 3gt<CR>
    :noremap <A-4> 4gt<CR>
    :noremap <A-5> 5gt<CR>
    :noremap <A-6> 6gt<CR>
    :noremap <A-7> 6gt<CR>
    :noremap <A-8> 8gt<CR>
    :noremap <A-9> 9gt<CR>
    :noremap <A-0> 0gt<CR>
endif

"Tab conflicts ctrl-i, so please use gt/gT instead
":noremap <Tab> :tabnext<CR>
":noremap <S-Tab> :tabprev<CR>

":noremap <c-w>t :tabnew<CR>:o ./<CR>
":noremap <s-t> :tabnew<CR>:o ./<CR>
":noremap <s-x> :tabnex<CR>
":noremap <s-z> :tabprev<CR>
":noremap <c-tab> :tabnex<CR>
":noremap <c-s-tab> :tabprev<CR>

" buffers
set hidden
nnoremap <Leader>n :bnext<CR>


" json
noremap <C-j> :!python -m json.tool<CR>


" grep/search
nnoremap GG :!clear<CR>:!grep "\<<cword>\>" * -rn --color<CR>
nnoremap GR :grep "\<<cword>\>" %:p:h/*<CR><CR>
nnoremap GW :grep "\<<cword>\>" * -rn --color<CR>:copen 10<CR>


" fuzzy search
noremap <C-p> :FZF<CR>


" line wrap
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function! ToggleWrap()
  if &wrap
    echo "Line Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
    silent! nunmap <buffer> <silent> k gk
    silent! nunmap <buffer> <silent> j gj
    silent! nunmap <buffer> <silent> 0 g0
    silent! nunmap <buffer> <silent> $ g$
  else
    echo "Line Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
  endif
endfunction


" gtags
":noremap <F2> :cclose
":noremap <F3> :GtagsCursor<CR>
":noremap <F4> :Gtags -g<SPACE>
":noremap <F6> :copen<SPACE>
":noremap <C-n> :cn<CR>
":noremap <C-p> :cp<CR>
":noremap <C-]> :GtagsCursor<CR>


" tagbar
":noremap <F6> :%!xxd
":noremap <F8> :TagbarToggle<CR>

