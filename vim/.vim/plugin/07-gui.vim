" ----------------------------------------------------------------------
" GUI and related Settings

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        " dark bg for gui
        hi  Normal          guifg=White     guibg=Black
        set lines=40
        set columns=100
        set guifont=Monospace\ 11
    endif

    vnoremap    <C-C>                   :w !DISPLAY=:0 xsel -b -i<CR><CR>

