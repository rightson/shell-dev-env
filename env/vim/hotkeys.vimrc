" vim hotkeys

":noremap <F2> :qa!

:noremap <F3> :cs find s <C-R>=expand("<cword>")<CR><CR>
:noremap <F4> :cs find e

:noremap <F5> :!cs update<CR>:cs reset<CR>
:noremap <F6> :%!xxd
:noremap <F8> :TagbarToggle<CR>
:noremap <F9> :if &mouse == 'a' \| set mouse= \| else \| set mouse=a \| endif<CR><CR>
:noremap <F12> :set nu!<CR>

:noremap <C-G> <Esc>:echo expand('%:p')<Return>

":noremap <F2> :cclose
":noremap <F3> :GtagsCursor<CR>
":noremap <F4> :Gtags -g<SPACE>
":noremap <F6> :copen<SPACE>
":noremap <C-n> :cn<CR>
":noremap <C-p> :cp<CR>
":noremap <C-]> :GtagsCursor<CR>

":noremap <F6> :%!xxd
"":noremap <F8> :%!python -m json.tool<CR><CR>

" Tab operations
nmap <C-w>t :tabnew %<CR>
":noremap <c-w>t :tabnew<CR>:o ./<CR>
":noremap <s-t> :tabnew<CR>:o ./<CR>
":noremap <s-x> :tabnex<CR>
":noremap <s-z> :tabprev<CR>
":noremap <c-tab> :tabnex<CR>
":noremap <c-s-tab> :tabprev<CR>
