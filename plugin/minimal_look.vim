" minimal_look.vim - Toggle whether status line, etc., are displayed.
" Author: Gábor Nyéki
" Version: 1.0

if exists("g:loaded_minimal_look") || &cp
    finish
endif
let g:loaded_minimal_look = v:true

let s:is_active = v:false
let s:original = {}

function! s:toggle_minimal_look()
    if s:is_active == v:false
        let s:is_active = v:true
        let s:original = {
                    \   "showmode": &showmode,
                    \   "ruler": &ruler,
                    \   "showcmd": &showcmd,
                    \   "number": &number,
                    \   "relativenumber": &relativenumber,
                    \   "laststatus": &laststatus,
                    \   "fillchars": &fillchars
                    \ }

        set noshowmode
        set noruler
        set noshowcmd
        set nonumber
        set norelativenumber
        set laststatus=0

        let l:fillchars = ['eob: ']

        " `,\@!` is negative lookahead for "not followed by comma."
        "
        for value in split(&fillchars, ',,\@!')
            if match(value, '^eob:') == -1
                let l:fillchars += [value]
            endif
        endfor

        let &fillchars = join(l:fillchars, ',')
    else
        let s:is_active = v:false

        if s:original["showmode"] == 1 | set showmode | endif
        if s:original["ruler"] == 1 | set ruler | endif
        if s:original["showcmd"] == 1 | set showcmd | endif
        if s:original["number"] == 1 | set number | endif
        if s:original["relativenumber"] == 1
            set relativenumber
        endif
        if s:original["laststatus"] > 0
            exec "set laststatus=" . s:original["laststatus"]
        endif
        if !empty(s:original["fillchars"])
            let &fillchars = s:original["fillchars"]
        endif
    endif
endfunction

nnoremap <Plug>ToggleMinimalLook :call <SID>toggle_minimal_look()<CR>

if !exists("g:minimal_look_no_mappings") || !g:minimal_look_no_mappings
   nmap <Leader>M <Plug>ToggleMinimalLook
endif
