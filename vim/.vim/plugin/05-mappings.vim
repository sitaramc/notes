" ----------------------------------------------------------------------
" Key (re)Mappings

    let     mapleader = "\\"

" ----------------------------------------------------------------------
" suspense
    " Find merge conflict markers
    " ? (should be in git section and need some other mapping) map <leader>mc /\v^[<\|=>]{7}( .*\|$)<CR>

    " (what is this?) let     g:no_vim_maps = 1       " we dont like [[ and ]]

" ----------------------------------------------------------------------
" help
    nnoremap    \hh                     :!cat $HOME/.vim/plugin/help.mkd<bar>less<CR>
    nnoremap    \hs                     :execute '!cat $HOME/.config/usnips/{all,' . &filetype . '}.snippets<bar>grep ^snippet<bar>less'<CR>

" ----------------------------------------------------------------------
" security
    nmap        <S-F5>                  :set modeline<bar>e!<CR>
    " manually force modelines when in root (and you trust the file)

" ----------------------------------------------------------------------
" change/enhance/fix defaults
    noremap     <C-^>                   <C-^>`"
    noremap     gf                      gf`"
    noremap     <C-G>                   2<C-G>

" ----------------------------------------------------------------------
" open/quit/navigate windows/buffers/files/directories/file system
    nmap        qq                      :qall<CR>
    imap        <F10>                   <C-O>:x<CR>
    nmap        <Leader><F10>           :xall<CR>

    " we use a non-std name for our ctags file because predictable traversal
    " of all tags become wonky when you hit an 'stag' that is also a 'tag'
    nnoremap    <C-]>                   :call F1112t(expand("<cword>"))<CR>:set tags=.git/ctags<CR><C-]>
    vnoremap    <C-]>                   y:call F1112t(@")<CR>:set tags=.git/stags<CR><C-]>
    nnoremap    \]t                     :call F1112t('')<CR>

" ----------------------------------------------------------------------
" display (wrap, highlights, ...)
    " open quickfix window
    nnoremap    <Leader>cw              :cw<CR>

    " spell
    nmap        <F1>                    :set invspell<CR>
    nnoremap    \]s                     :nnoremap [ [s<bar>nnoremap ] ]s<bar>normal ]s<CR>

" ----------------------------------------------------------------------
" movement and navigation within buffer
    " experimental
    " nmap        <Space>                 Lzt
    " nmap        b                       Hz-
    nmap        <C-J>                   zjzxzt
    nnoremap    <C-K>                   zkzx[zzt

    " search
    nmap        z/                      :SearchOpenFoldsAndHeaders<Space>
    nmap        <C-N>                   :call SearchOpenFoldsAndHeaders('')<CR>
    " adapted from http://vim.wikia.com/wiki/The_super_star, but using #
    nnoremap    #                       :set hls<CR>:exec "let @/='\\<" . expand("<cword>") . "\\>'"<CR>

    " folding
    nmap        -                       za
    nmap        _                       :call ToggleAllFolds()<CR>
    nmap        <C-_>                   :call CycleMKDFoldExpr()<CR>
    nmap        <F5>                    :call ToggleFdm()<CR>
    " adapted from http://vim.wikia.com/wiki/Folding_with_Regular_Expression
    " added "set hls", added an extra <CR> at the end
    nnoremap    \z                      :set hls<bar>nnoremap [ zk<bar>nnoremap ] zj<CR>:setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-2)=~@/)\\|\\|(getline(v:lnum+2)=~@/)?1:2 foldmethod=expr foldlevel=1<CR><CR>

" ----------------------------------------------------------------------
" editing
    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap    .                       :normal .<CR>
    set         pastetoggle=\\P
    nmap        \jl                     :g/./,/^$/-j<CR>
    vmap        \jl                     :g/./,/^$/-j<CR>
    nmap        \sq                     :g/^$/,/./-j<CR>
    vmap        \sq                     :g/^$/,/./-j<CR>
    nmap        <C-Up>                  dap{{p
    nmap        <C-Down>                dap}p
    nmap        <C-Left>                <ap
    nmap        <C-Right>               >ap
    vmap        <C-Up>                  dkP`[V`]
    vmap        <C-Down>                dp`[V`]
    vmap        <C-Left>                <`[V`]
    vmap        <C-Right>               >`[V`]
    nnoremap    \13                     mmggVGg?`m:inoremap <lt>space> <lt>space><lt>esc>mmg?B`ma<cr>
    nnoremap    \26                     mmggVGg?`m:iunmap   <lt>space><cr>

    " (not exactly maps, but meh...)
    " 2019-11-04    causes errors (it still works, but ends up screwing some of my commands, like 'gs')
    " :iab        <expr> <C-V>d           strftime("%F")
    " :iab        <expr> <C-V>t           strftime("%F.%T")
    :iab        <expr> <C-V>-           repeat('-', 70)

    " reformat
    inoremap    \\                      <Esc>gwapa
    nnoremap    \f                      gqap

    " inline calculator, insert and visual mode ^\=
    inoremap    <C-\>=                  <C-O>yiW<End> = <C-R>=<C-R>0<CR>
    vnoremap    <C-\>=                  y`>a = <C-R>=<C-R>0<CR>

" ----------------------------------------------------------------------
" terminal
    nmap        <F6>                    :lcd %:p:h<CR>:let $V0=expand("%")<CR>:let $V1=expand("#")<CR>:terminal ++noclose<CR><C-W>p:cd -<CR><C-W>p
    nmap        <S-F6>                  :lcd %:p:h<CR>:let $V0=expand("%")<CR>:let $V1=expand("#")<CR>:terminal ++noclose<CR><C-W>p:cd -<CR><C-W>p <C-W>"#<C-A>
    tnoremap    <F6>                    <C-W>N
    tnoremap    <F3>                    <C-D>
    au TerminalOpen         *
                            \   if &buftype == 'terminal' |
                            \       map <buffer> <F6> i|
                            \   endif

