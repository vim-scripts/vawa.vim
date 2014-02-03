" Vawa Plugin for VIM > 7.3 version 1.00
" Maintainer:	Sandeep.c.r<sandeepcr2@gmail.com>

function! s:vawa()
    call clearmatches()
    let s:temp = getpos('.')
    let s:current_col = s:temp[2]
    let s:current_line = s:temp[1]
    let s:temp = searchpos('[>$]','bcn')
    let s:dollar_line = s:temp[0]
    let s:dollar_col = s:temp[1]
    if(s:dollar_line != s:current_line)
        return
    endif
    let s:temp = getbufline(bufnr('%'),line('.'))
    let s:varend = match(s:temp[0], '[^a-zA-Z0-9_\x7f-\xff]\|\n', s:dollar_col)+1
    let s:space_col = s:varend
    if((s:space_col > s:dollar_col) && ( s:space_col< s:current_col))
        return
    endif
    if(s:varend == 0)
        let s:varend = strlen(s:temp[0])+1
    endif
    let s:current_char = s:temp[0][s:current_col-1]
    if(s:current_char == '>' || s:current_char == '-')
        return
    endif
    if(exists("g:vawahl"))
        exe "highlight VarHl  " . g:vawahl
    else
        highlight VarHl  ctermbg=black ctermfg=red guifg=#ff0000 guibg=#000000 ctermfg=LightRed gui=bold
    endif
    let s:str = strpart(s:temp[0], s:dollar_col-1,(s:varend - s:dollar_col))
    let s:prefix = ''
    if(exists("g:vawanohlcurrent") && (g:vawanohlcurrent == 1))
        let s:lineab = s:current_line - 1
        let s:linebe = s:current_line + 1
        let s:colbf  = s:dollar_col + 1
        let s:prefix = '\(\%>'.s:lineab.'l.\%<'.s:linebe.'l.\%>'.s:colbf.'c\)\@!'
    endif
    if(strpart(s:str,0,1) == '>')
        let s:str = strpart(s:str ,1)
        call matchadd('VarHl', s:prefix.'>\@<='. s:str.'\n\{-\}\(\([^a-zA-Z0-9_\x7f-\xff]\)\|$\)\@=')
    else
        call matchadd('VarHl', s:prefix.s:str.'\n\{-\}\(\([^a-zA-Z0-9_\x7f-\xff]\)\|$\)\@=')
    endif
endfunction
if(!exists("g:vawanoauto") || (g:vawanoauto == 1))
    augroup HighlightVar
            autocmd!
            au CursorMoved *.php call <sid>vawa()
            au CursorMovedi *.php call <sid>vawa()
    augroup END
endif

command! Vawa :call <sid>vawa()
