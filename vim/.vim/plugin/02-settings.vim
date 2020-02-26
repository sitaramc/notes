" ----------------------------------------------------------------------
" simple settings

" do we even *need* this file now?

    set     foldtext=MYfoldtext()
    set     grepprg=rg\ -uu\ -g\ '!.git'\ -S\ --vimgrep
    set     grepformat^=%f:%l:%c:%m
    set     guioptions+=c
    set     keywordprg=wnb
    set     swapsync=
    set     ttyscroll=3
    set     viminfo='200
    set     wildcharm=<C-Z>

    set     path=.,,**
    set     tags=.git/ctags

    set     mouse=r
    set     t_Co=256

