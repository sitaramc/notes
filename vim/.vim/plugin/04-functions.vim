" ----------------------------------------------------------------------
" Functions; all in one place

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            normal zv
            return 1
        endif
    endfunction

    function FoldLevel(patt)
        if !empty(a:patt) && getline(v:lnum)=~a:patt
            return ">1"
        endif
        " lines like '# ---- some text ----'
        if getline(v:lnum)=~'^\s*. ----.*[^-]'
            return ">1"
        endif
        if getline(v:lnum-1)=~'^\s*. -----*$'
            return ">1"
        endif
        return "="
    endfunction

    function! SearchOpenFoldsAndHeaders(pattern)
        if a:pattern != ''
            let @/=a:pattern
            " start search from the top
            1
        endif

        " move to the next eligible line which contains the pattern.  Note
        " that we miss multiple matches on the same line this way.
        for lnum in range(line(".")+1,line("$"))
            if ( foldclosed(lnum) == lnum || foldclosed(lnum) == -1 ) && getline(lnum) =~ @/
                execute lnum
                return
            endif
        endfor
        echohl ErrorMsg
        echo "E486: No more matches: " . @/
        echohl Normal
    endfunction
    command! -nargs=* SearchOpenFoldsAndHeaders call SearchOpenFoldsAndHeaders(<q-args>)

    function ToggleAllFolds()
        if &fdl == 0
            set fdl=99
        else
            set fdl=0
        endif
    endfunction

    function CycleMKDFoldExpr()
        if &foldexpr=="FoldLevel('^#')"
            setlocal foldmethod=expr
            setlocal foldexpr=FoldLevel('^#\ ')
        elseif &foldexpr=="FoldLevel('^#\ ')"
            setlocal foldmethod=expr
            setlocal foldexpr=FoldLevel('^##\\?\ ')
        else
            setlocal foldmethod=expr
            setlocal foldexpr=FoldLevel('^#')
        endif
    endfunction

    function MYfoldtext()
        let fs  = printf('%4d  ', (v:foldend-v:foldstart))
        let l   = getline(v:foldstart)
        if l =~ '^# '   " special case H1 lines if they start a fold
            return ' *' . fs . l
        else
            return '  ' . fs . l
        endif
    endfunction

    function ToggleFdm()
        if &fdm=="expr"
            set fdm=indent
            set fdl=0
        elseif &fdm=="indent"
            set fdm=manual
            execute "normal zE"
        elseif &fdm=="manual"
            set fdm=expr
            execute "normal zx"
        endif
        set fdm ?
    endfunction

    function! F1112t(...)
        call matchadd("Myh4", a:1)
        nnoremap [ :tprev<CR>zv
        nnoremap ] :tnext<CR>zv
    endfunction

    " remove this completely after 2020-06-22
    " function! Grep(...)
    "     let cmd = join(a:000, "\n")
    "     let cmd = substitute(cmd, " ", "\\\\ ", "g")
    "     let cmd = substitute(cmd, "\n", " ", "g")
    "     let cmd = "lgrep " . cmd

    "     " a bit kludgey, but will do for now
    "     let @/=a:1
    "     if @/ =~ '^-'
    "         let @/=a:2
    "     endif
    "     if @/ =~ '^-'
    "         let @/=a:3
    "     endif

    "     silent exec cmd
    "     set hls
    "     call F1112l()
    "     redraw!
    " endfunction
    " command! -nargs=* Grep :call Grep(<f-args>)

