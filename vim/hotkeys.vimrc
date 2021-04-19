" buffer
map <C-k> :bn<CR>
map <C-l> :ls<CR>


" tab
map <C-j> gt<CR>


" tab
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


" Function key overwrite

noremap <F3> :cs find s <C-R>=expand("<cword>")<CR><CR>

" similar to alt-F4 / ctrl-F4
noremap <F4> :qa<CR>

" refresh vimrc
noremap <F5> :source ~/.vimrc<CR>

noremap <F6> :NERDTreeToggle<CR>

noremap <S-F11> :call ToggleDrawCentered()<CR>

noremap <F12> :call ToggleLineNumber()<CR>

" search and replace
noremap <C-G> <Esc>:echo expand('%:p')<Return>


" grep/search
nnoremap GG :!clear<CR>:!grep "\<<cword>\>" * -rn --color<CR>
nnoremap GR :grep "\<<cword>\>" %:p:h/*<CR><CR>
nnoremap GW :grep "\<<cword>\>" * -rn --color<CR>:copen 10<CR>

