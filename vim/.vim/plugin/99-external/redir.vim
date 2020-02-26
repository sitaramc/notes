" from a comment in https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
" Redirect the output of a Vim command into a scratch buffer
" does NOT seem to work for external commands, though the main code in that link does (if you really need it)
function! Redir(cmd) abort
    let output = execute(a:cmd)
    tabnew
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    call setline(1, split(output, "\n"))
endfunction
command! -nargs=1 Redir silent call Redir(<f-args>)
