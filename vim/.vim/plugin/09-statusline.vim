let s:gitbranch = ''
augroup getgitbranch
    au!
    au BufWinEnter  * let s:gitbranch = MSL_GitBranch()
    " this is to avoid running git rev-parse too often
augroup END
function! MSL_GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

hi User1 cterm=none ctermfg=black ctermbg=yellow    guifg=black guibg=yellow
hi User2 cterm=none ctermfg=black ctermbg=red       guifg=black guibg=red
hi User3 cterm=bold ctermfg=white ctermbg=darkblue  guifg=white guibg=darkblue

hi User9 cterm=bold ctermfg=white ctermbg=black     guifg=white guibg=black

function! MyStatusLine() abort
    let focused = g:statusline_winid == win_getid(winnr())
    let hln = '%#Normal#'

    " seems the simplest way to set colors for the not-current window, with
    " some flexibility to change individual pieces later if needed
    if focused
        let hl1 = '%#User1#'
        let hl2 = '%#User2#'
        let hl3 = '%#User3#'
    else
        let hl1 = '%#User9#'
        let hl2 = '%#User9#'
        let hl3 = '%#User9#'
    endif

    let msl = ''

    " paste flag comes first!
    if &paste
        let msl = msl . hl2 . '[PASTE]' . hln . ' '
    endif

    " filename, plus flags like RO, modified, modifiable, etc
    let msl = msl . hl1.'%f'.hln . '%a%( '.hl2.'%m'.hln.'%)'
    if strlen(s:gitbranch) > 0
        let msl = msl . ' ' . hl3 . s:gitbranch . hln
    endif
    if ! &modifiable || &readonly
        let msl = msl . ' ' . hl2 . '%r%w%q' . hln
    else
        let msl = msl . ' ' . '%r%w%q'
    endif

    " encrypted file?  warn about weak encryption
    if exists("+key") && !empty(&key)
        if &cryptmethod == 'blowfish2'
            let msl = msl . hl2 . '[crypt]' . hln
        else
            let msl = msl . hl2 . '[WEAK: ' . &cryptmethod . ']' . hln
        endif
    endif
    if &spell
        let msl = msl . '[spell]'
    endif

    " file format, encoding, type
    if &fileformat != 'unix'
        let msl = msl . hl2 . '[' . &fileformat . ']' . hln
    endif
    let msl = msl . '[' . &fileencoding . ']' . hl3 . '%y' . hln

    " right align from here
    let msl = msl . "%="

    " type, col/line numbers
    let msl = msl . ' %8(%c%V%) ' . hl3 . '%6l / %6L (%p%%)'

    " finally!
    return msl
endfunction
set statusline=%!MyStatusLine()
