" vimrc
" vim: ts=24 fdm=expr fdl=0

" ----------------------------------------------------------------------
" to use this on someone else's env:
"   export VIMINIT="so /your/.vimrc" (or " alias vim to 'vim -u /your/.vimrc'),
"   then add a 'set rtp+=/your/.vim' line to your vimrc.

" ----------------------------------------------------------------------
" experimental... (to be moved later)

    vmap        \p          !pandoc<CR>
    nmap        \H          :normal jjdGo<Esc>:r /tmp/quote.html<CR>4ko<CR><Esc>:r ~/.config/mutt/__sigtcs<CR>>}}O<CR>----<Esc>{{<CR>V}}}k!pandoc<CR>kko
    imap        \H          <Esc>Vgg}<CR>!pandoc<CR>

" ----------------------------------------------------------------------
" all **absolutely** essential settings in one file, for those servers where I really just need the basics in one file

    filetype plugin indent on
    syntax on

" ----------------------------------------------------------------------
" cheap settings

    " hit F1 in insert mode to get a date and time plus 4 spaces, ready to type text
    inoremap    <F1>                    <C-O>"=strftime('%F %H:%M')<CR>P    

    " allow "gq" for bullet lists using "*": remove mb:*, add fb:*
    " XXX if you change these, also change them wherever they appear later
    set     formatoptions=tcqnlj
    set     comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:*,b:--,fb::

    set     autoindent
    set     background=dark
    set     backspace=indent,eol,start
    set     breakindent
            let    &showbreak = '↳ '
    set     breakindentopt=sbr
    set     expandtab
    set     fillchars-=fold:-
    set   nofsync
    set     hidden                      " Allow buffer switching without saving
    set     history=1000
    set     hlsearch
    set     ignorecase
    set     incsearch
    set     joinspaces
    set     laststatus=2
    set     linebreak
    set     list
    set     listchars=tab:›\ ,trail:•,extends:#,nbsp:.
    set     matchpairs+=<:>
    set     nrformats=alpha,hex
    set     number
    set     report=0
    set     scrolloff=2
    set     scrollopt=ver,jump,hor
    set     shiftwidth=4
    set     shortmess+=a                " ? we could add more flags if needed
    set     showcmd
    set     showmatch
    set     showmode
    set     smartcase
"    set     smartindent
    set     softtabstop=4
    set   noswapfile
"    set     tabstop=4
    set     textwidth=78
    set   nottyfast
    set     virtualedit=block           " ? try it out...
    set     wildmenu
    set     wildmode=list:longest,full

" ----------------------------------------------------------------------
" cheap mappings

    nmap        <F2>                    :set wrap!<CR>
    nmap        <F3>                    :q<CR>
    nmap        <F9>                    :update<CR>
    imap        <F9>                    <C-O>:update<CR>
    nmap        <Leader><F9>            :wall<CR>
    nmap        <F10>                   :x<CR>
    nmap        <C-\>q                  :se t_ti= t_te= <bar> q<CR>

    nmap        <F7>                    :Next<CR>
    nmap        <F8>                    :next<CR>
    nmap        <Tab>                   <C-W><C-W>
    nmap        \o                      <C-W>o

    nnoremap    <Leader>cd              :lcd %:h<CR>

    nnoremap    <silent> <C-L>          :set hls!<CR>:call clearmatches()<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
    " this was from tpope's sensible.vim, IIRC

    nmap        \\                      zt

    nmap        \db                     :set diffopt+=iwhite<CR>
    nmap        \D                      :DiffOrig<CR>
                                command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

    if &diff
        syncbind
        nnoremap [      [czzzv
        nnoremap ]      ]czzzv
        nnoremap do     do]c
        nnoremap dp     dp]c
        nmap     <F2>   :set wrap!<CR>:wincmd p<CR>:set wrap!<CR>:wincmd p<CR>
        exec("syntax off")
    endif
    set         diffopt+=vertical

    " CTRL-U in insert mode deletes a lot. Put an undo-point before it.
    inoremap <C-u> <C-g>u<C-u>
    " https://sharats.me/posts/automating-the-vim-workplace/

" ----------------------------------------------------------------------
" vanilla commands to explore files/content, in case plugins don't load.  This
" includes basic netrw settins for use with ':Lex'

    let     g:netrw_browsex_viewer  = "xo"
    let     g:netrw_preview         = "1"
    let     g:netrw_sftp_cmd        = "sftp -q"
    let     g:netrw_silent          = 0
    let     g:netrw_browse_split    = 4
            " if this causes problems, '3' (new tag) is safer
    au      WinEnter                    *   if &ft == 'netrw'|vert resize 32|endif

" load files whose names contain string
    command! -nargs=+ VD n `find -L .  -name .git -prune -o -name .cache -prune -o -type f -print \| grep -i <args>`

" load files whose contents contain string
    nnoremap    \*                      :let @/=expand("<cword>")<CR>:silent grep -w <C-R>/<CR>:silent redraw!<CR>
    nnoremap    \/                      :                             silent grep    <C-R>/<CR>:silent redraw!<CR>
    vnoremap    \/                      "vy:let @/=@v<CR>:            silent grep  '<C-R>/'<CR>:silent redraw!<CR>

    function! VG(...)
        let     @/ = a:1

        let     cmd = join(a:000, "\n")
        let     cmd = substitute(cmd, " ", "\\\\ ", "g")
        let     cmd = substitute(cmd, "\n", " ", "g")
        let     cmd = "grep " . cmd
        silent  exec cmd
        set     hls
        set     nowrap
        redraw!
    endfunction
    command! -nargs=* VG :call VG(<f-args>)
    set grepprg=grep\ -Hrin\ $*     " vanilla default if not overridden later

    augroup resCur
        au!
        au  BufWinEnter             *           normal! g`"zv
    augroup END

" ----------------------------------------------------------------------
" possibly junk!
" 2019-12-23 let's try getting rid of it for some time, say 6 months :)
" " leaving this here because it seems kludgey, and I want it "in my face" so I can fix it.  Eventually!
" if &term =~ '^screen'
"     " tmux will send xterm-style keys when its xterm-keys option is on
"     execute "set <xUp>=\e[1;*A"
"     execute "set <xDown>=\e[1;*B"
"     execute "set <xRight>=\e[1;*C"
"     execute "set <xLeft>=\e[1;*D"
" endif

" 2019-12-23 let's try getting rid of it for some time, say 6 months :)
" " another mysterious/kludgey bit of code
" " copied verbatim from older .spf13-vim-3/.vimrc, since deleted on spf13,
" " but it seems we need it to use arrow keys in insert mode!  Other
" " symptoms I have noticed if you remove these lines is F10 in insert
" " mode doesn't work either (you have to press it twice).
"     " Fix home and end keybindings for screen, particularly on mac
"     " - for some reason this fixes the arrow keys too. huh.
" map         [F $
" imap        [F $
" map         [H g0
" imap        [H g0

" ----------------------------------------------------------------------
" quickfix lists

    augroup basics
        au!

        " global autocommands to set ][ mode
        au  filetype                qf          nnoremap [ :cprevious<CR>zv | nnoremap ] :cnext<CR>zv
        au  filetype                qf          set statusline=%!MSL()
        au  QuickFixCmdPost         *grep*      cwindow

    augroup END

" ----------------------------------------------------------------------
" highlights

    " highlighting multiple strings on screen (3 highlights hardcoded)
    hi          Myh1                    ctermbg=DarkMagenta     guibg=DarkMagenta
    hi          Myh2                    ctermbg=DarkGreen       guibg=DarkGreen
    hi          Myh3                    ctermbg=DarkCyan        guibg=DarkCyan
    hi          Myh4                    cterm=reverse           gui=reverse
    hi          Myhc                    ctermbg=Blue            guibg=Blue
    nmap        \h1                     :let h1=matchadd("Myh1", expand("<cword>"))<CR>
    nmap        \h2                     :let h2=matchadd("Myh2", expand("<cword>"))<CR>
    nmap        \h3                     :let h3=matchadd("Myh3", expand("<cword>"))<CR>
    nmap        <F4>                    :let h4=matchadd("Myh4", expand("<cword>"))<CR>
    nmap        \hc                     :let hc=matchadd("Myhc", "\\%".col(".")."c")<CR>
    nmap        \hr                     :let hr=matchadd("Myhc", @/)<CR>
    nmap        \h0                     :let h0=clearmatches()<CR>
    vmap        <F1>                    "hy:let h1=matchadd("Myh1", @h)<CR>
    vmap        <F2>                    "hy:let h2=matchadd("Myh2", @h)<CR>
    vmap        <F3>                    "hy:let h3=matchadd("Myh3", @h)<CR>
    vmap        <F4>                    "hy:let h4=matchadd("Myh4", @h)<CR>
    nnoremap    <bar>                   :set hls<CR>:exec "let @/='\\%".col(".")."c'"<CR>

" ----------------------------------------------------------------------
" statusline

    hi User1 cterm=none ctermfg=black ctermbg=yellow    guifg=black guibg=yellow
    hi User2 cterm=none ctermfg=black ctermbg=red       guifg=black guibg=red
    hi User3 cterm=bold ctermfg=white ctermbg=darkblue  guifg=white guibg=darkblue

    hi User9 cterm=bold ctermfg=white ctermbg=black     guifg=white guibg=black

    hi StatusLineNC cterm=none

    let s:gitbranch = ''
    augroup getgitbranch
        au!
        au BufWinEnter  * let s:gitbranch = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
        " this is to avoid running git rev-parse too often
    augroup END

    function! MSL() abort
        let msl = ''

        if &paste                       | let msl = msl . '%2*[PASTE]%* '                           | endif
        let                                   msl = msl . '%3*%f%*%a%(%2*%m%*%)'
        if strlen(s:gitbranch) > 0      | let msl = msl . ' %1*' . s:gitbranch . '%*'               | endif
        let                                   msl = msl . ' %2*%r%w%q%*'
        if !empty(&key)                 | let msl = msl . '%2*[' . &cryptmethod . ']%*'             | endif
        if &spell                       | let msl = msl . '[spell]'                                 | endif
        if &fileformat != 'unix'        | let msl = msl . '%2*[' . &fileformat . ']%*'              | endif
        let                                   msl = msl . '[' . &fileencoding . ']' . '%1*%y%*'

        " right align from here
        let msl = msl . '%= %8(%c%V%) %3*%6l / %6L (%p%%)'

        " finally!
        return msl
    endfunction
    set statusline=%!MSL()
