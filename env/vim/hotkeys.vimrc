" vim hotkeys


:noremap <F2> :qa!
:noremap <F3> :Gtags<SPACE>
:noremap <F4> :GtagsCursor<CR>
:noremap <F5> :source ~/.vimrc<CR> :diffupdate<CR>:f<CR>
:noremap <F6> :%!xxd
:noremap <F9> :if &mouse == 'a' \| set mouse= \| else \| set mouse=a \| endif<CR><CR>
:noremap <F12> :set nu!<CR>

:noremap <C-n> :cn<CR>
:noremap <C-p> :cp<CR>
:noremap <C-c><C-o> :copen<CR>
:noremap <C-c><C-c> :cclose<CR>
:noremap <C-\><C-]> :GtagsCursor<CR>


":noremap <F2> :qa!
":noremap <F3> *
":noremap <F4> :source ~/.vimrc<CR> :diffupdate<CR><CR>
":noremap <F5> :NERDTree<CR>
":noremap <s-F5> :NERDTreeClose<CR>
":noremap <F6> :%!xxd
"":noremap <F8> :%!python -m json.tool<CR><CR>
":noremap <F8> :TlistOpen<CR>
":noremap <F9> :if &mouse == 'a' \| set mouse= \| else \| set mouse=a \| endif<CR><CR>
":noremap <F11> :if &laststatus==2 \| set laststatus=1 \| else \| set laststatus=2 \| endif<CR><CR>
":noremap <F12> :set nu!<CR>


" Tab operations
":noremap <c-w>t :tabnew<CR>:o ./<CR>
":noremap <s-t> :tabnew<CR>:o ./<CR>
":noremap <s-x> :tabnex<CR>
":noremap <s-z> :tabprev<CR>
":noremap <c-tab> :tabnex<CR>
":noremap <c-s-tab> :tabprev<CR>

" Tab operation v2
" nmap <D-t> :tabnew<cr>
" nmap <D-w> :close<cr>
" nmap <D-1> 1gt
" nmap <D-2> 2gt
" nmap <D-3> 3gt
" nmap <D-4> 4gt
" nmap <D-5> 5gt
" nmap <D-6> 6gt
" nmap <D-7> 7gt
" nmap <D-8> 8gt
" nmap <D-9> 9gt
" nmap <D-0> 10gt
"
" nmap <D-Up> :tabnew<CR>
" nmap <D-Right> :tabnext<CR>
" nmap <D-Left> :tabprevious<CR>
"
" nmap <D-o> :tabnew<CR><D-o>
"
" nmap <D-s>:mksession! ~/session.vim<CR>:wa<CR>
" nmap SQ <ESC>:mksession! ~/session.vim<CR>:wqa<CR>

