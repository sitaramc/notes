" ----------------------------------------------------------------------
" "global" autocmds -- encrypted and tmp files (like nb files)

if empty($GPG_KEYID)
    let $GPG_KEYID = 'sitaramc@gmail.com'
endif

augroup gpgedit
    au!
    au  BufReadPre,FileReadPre  /tmp/*      set nobackup
    au  BufReadPre,FileReadPre  /tmp/*      set noswapfile
    au  BufReadPre,FileReadPre  /tmp/*      set noundofile
    au  BufReadPre,FileReadPre  /tmp/*      set nowritebackup
    au  BufReadPre,FileReadPre  /tmp/*      set viminfo=
    au  BufReadPre,FileReadPre  /tmp/*      set sh=/bin/bash

    " Use gpg2 to open a .gpg file
    " adapted from http://lwn.net/Articles/226514/
    au  BufReadPre,FileReadPre  *.gpg       set nobackup
    au  BufReadPre,FileReadPre  *.gpg       set noswapfile
    au  BufReadPre,FileReadPre  *.gpg       set noundofile
    au  BufReadPre,FileReadPre  *.gpg       set nowritebackup
    au  BufReadPre,FileReadPre  *.gpg       set viminfo=
    au  BufReadPre,FileReadPre  *.gpg       set sh=/bin/bash
    au  BufReadPost             *.gpg       :%!gpg2 -q -d
    au  BufReadPost             *.gpg       | redraw
    au  BufWritePre             *.gpg       :%!gpg2 -q -e --no-encrypt-to --no-default-recipient -r $GPG_KEYID -a
    au  BufWritePost            *.gpg       u
    au  VimLeave                *.gpg       :!clear
augroup END

" ----------------------------------------------------------------------
" "global" autocmds -- eml (vim from thunderbird)

augroup eml
    au!
    au  BufReadPre,FileReadPre  *.eml       set tw=72
    au  filetype                mail        let h1=matchadd("Myh1", "Subject:.*")
    au  filetype                mail        let h2=matchadd("Myh2", "From:.*")
    au  filetype                mail        set rtp^=~/.config/mutt
augroup END

" ----------------------------------------------------------------------
" "global" autocmds -- general

augroup persist
    au!
    " au  BufReadPre,FileReadPre  *       NeoComplCacheLock
    au  BufReadPost             *           set    formatoptions=tcqnlj
    au  BufReadPost             *           set    comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:*,b:--,fb::

    " au    BufReadPost             *       hi     GitGutterAddDefault          ctermbg=Black guibg=Black
    " au    BufReadPost             *       hi     GitGutterChangeDefault       ctermbg=Black guibg=Black ctermfg=blue
    " au    BufReadPost             *       hi     GitGutterChangeDeleteDefault ctermbg=Black guibg=Black ctermfg=cyan
    " au    BufReadPost             *       hi     GitGutterDeleteDefault       ctermbg=Black guibg=Black
    au  BufReadPost             *           hi     SignColumn                   ctermbg=Black guibg=Black
    au  BufReadPost  fugitive://*           set    bufhidden=delete

    au  BufNewFile,BufRead      *
            \ if getline(1) =~ 'text/x-zim-wiki' |
            \   set filetype=zim |
            \ endif

    au  BufNewFile,BufRead      *
            \ if getline(1) =~ '^% ' |
            \   set filetype=markdown |
            \ endif

    au  BufEnter                *
            \ if &filetype == 'mail' |
            \   set filetype=markdown |
            \ endif

    " global autocommands to set ][ mode
    au  DiffUpdated             *           nnoremap [ [czzzv | nnoremap ] ]czzzv

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au  FileType                gitcommit   au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

augroup END

" more global autocommands (folding)

augroup foldingathome
    au!
    au  FileType                *           setlocal foldmethod=indent
    au  FileType                *           setlocal foldlevel=99
    au  FileType                *           setlocal foldexpr=FoldLevel('')
    au  FileType                sh          setlocal foldexpr=FoldLevel('^[a-z_]\\+()')
    au  FileType                perl        setlocal foldexpr=FoldLevel('^\\s*sub\\s')
    au  FileType                zim         setlocal foldmethod=expr
    au  FileType                zim         setlocal foldexpr=FoldLevel('^==')
    au  FileType                markdown    setlocal foldexpr=FoldLevel('^#')
    au  FileType                markdown    setlocal foldmethod=expr
    au  FileType                markdown    setlocal nosmartindent
    au  BufEnter                todo        map <buffer> <Leader>t /^TODO:<CR>\zzm
    au  BufEnter                todo        map <buffer> <Leader>d 06clDONE: dt<TAB><TAB><Esc>dapGp''
augroup END
