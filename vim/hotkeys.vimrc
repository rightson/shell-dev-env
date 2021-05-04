map <C-p> :FZF<CR>

" buffer
map BN :bn<CR>
map BP :bp<CR>
map LS :ls<CR>


" tab
map <C-j> gt<CR>
map <C-k> gT<CR>


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
noremap <F5> :silent! cs kill 0<CR> :mapclear<CR> :source ~/.vimrc<CR> cs add cscope.out<CR>

noremap <F6> :NERDTreeToggle<CR>

noremap <F10> <C-w>\|<C-w>_
noremap <S-F10> <C-w>=

noremap <F12> :call ToggleLineNumber()<CR>

" search and replace
noremap <C-G> <Esc>:echo expand('%:p')<Return>


" grep/search
"nnoremap GG :!clear<CR>:!grep "\<<cword>\>" * -rn --color<CR>
"nnoremap GR :grep "\<<cword>\>" %:p:h/*<CR><CR>
nnoremap GG :grep "\<<cword>\>" * -rn --color<CR>:copen 10<CR>
nnoremap GC :cclose<CR>

