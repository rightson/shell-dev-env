" hotkeys for Rightson Chen

" Tab operations
:noremap <c-w>t :tabnew<CR>:o ./<CR>
:noremap <s-t> :tabnew<CR>:o ./<CR>
:noremap <s-x> :tabnex<CR>
:noremap <s-z> :tabprev<CR>
:noremap <c-tab> :tabnex<CR>
:noremap <c-s-tab> :tabprev<CR>

" Quit all
:noremap <F2> :qa!

" Next
:noremap <F3> *

" Reload setting
:noremap <F4> :source ~/.vimrc<CR> :diffupdate<CR><CR>

" File explorer
:noremap <F5> :NERDTree<CR>
:noremap <s-F5> :NERDTreeClose<CR>

" Convert to hex
:noremap <F6> :%!xxd

" Beautify JSON
:noremap <F8> :%!python -m json.tool<CR><CR>

" Toggle mouse
:noremap <F9> :if &mouse == 'a' \| set mouse= \| else \| set mouse=a \| endif<CR><CR>
:noremap <F11> :if &laststatus==2 \| set laststatus=1 \| else \| set laststatus=2 \| endif<CR><CR>

" Toggle line number
:noremap <F12> :set nu!<CR>

nmap <C-s-t> :%s/\s\+$//<CR>

" Tabs
""" nmap <D-t> :tabnew<cr>
""" nmap <D-w> :close<cr>
""" nmap <D-1> 1gt
""" nmap <D-2> 2gt
""" nmap <D-3> 3gt
""" nmap <D-4> 4gt
""" nmap <D-5> 5gt
""" nmap <D-6> 6gt
""" nmap <D-7> 7gt
""" nmap <D-8> 8gt
""" nmap <D-9> 9gt
""" nmap <D-0> 10gt
"""
""" nmap <D-Up> :tabnew<CR>
""" nmap <D-Right> :tabnext<CR>
""" nmap <D-Left> :tabprevious<CR>
"""
""" nmap <D-o> :tabnew<CR><D-o>
"""
""" nmap <D-s>:mksession! ~/session.vim<CR>:wa<CR>
""" nmap SQ <ESC>:mksession! ~/session.vim<CR>:wqa<CR>
