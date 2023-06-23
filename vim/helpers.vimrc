function! ToggleGuiMenu()
    if has("gui_running")
        if !exists('g:toggle_gui_menu')
            let g:toggle_gui_menu = 1
        endif
        if (g:toggle_gui_menu == 1)
            set guioptions-=m
            let g:toggle_gui_menu = 0
        else
            set guioptions+=m
            let g:toggle_gui_menu = 1
        endif
    endif
endfunction


function! ToggleGuiToolbar()
    if has("gui_running")
        if !exists('g:toggle_gui_toolbar')
            let g:toggle_gui_toolbar = 1
        endif
        if (g:toggle_gui_toolbar == 1)
            set guioptions-=T
            let g:toggle_gui_toolbar = 0
        else
            set guioptions+=T
            let g:toggle_gui_toolbar = 1
        endif
    endif
endfunction


function! ToggleMouse()
    if &mouse == 'a'
        set mouse=
    else
        set mouse=a
    endif
endfunction


function! ToggleLineNumber()
    if &nu == 'nonumber'
        set nu
    else
        set nonu
    endif
endfunction


function! ToggleDrawCentered()
    Goyo
endfunction


function! HighlightColumn()
    set colorcolumn=120
    let &colorcolumn=join(range(120,999),",")
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
    set fillchars+=vert:\
endfunction


function! ShowCursorLine()
    set cursorline
    highlight cursorLine cterm=bold ctermbg=DarkGrey gui=bold guibg=DarkGrey
    highlight CursorLineNr term=bold cterm=bold ctermbg=DarkGrey gui=bold
endfunction


function! StripTrailingWhitespace()
    " Set a mark ('m') at the current cursor position
    normal! mm
    " Do the substitution
    %s/\s*$//e
    " Return to the mark ('m')
    normal! `m
endfunction

function! CscopeAdd()
    !cs add
    cs add cscope.out
endfunction


function! CscopeUpdate()
    !cs update
    cs reset
endfunction


function! ScreenFilename()
    if has('amiga')
        return "s:.vimsize"
    elseif has('win32')
        return $HOME.'\_vimsize'
    else
        return $HOME.'/.vimsize'
    endif
endfunction


if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
endif


if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
endif


function! ScreenSave()
    " Save window size and position.
    if has("gui_running") && g:screen_size_restore_pos
        let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
        let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
                    \ (getwinposx() < 0? 0: getwinposx()) . ' ' .
                    \ (getwinposy() < 0? 0: getwinposy())
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
                normal<C-w><C-=>
                return
            endif
        endfor
    endif
endfunction

function! DefaultDark()
    colo default
    set bg=dark
    if &diff
        colo koehler
    endif
endfunction

function! DefaultLight()
    colo default
    set bg=light
    if &diff
        colo light
    endif
endfunction
