" stuff that is conditional on something

if !isdirectory($HOME . '/.cache/vim')
    call mkdir( $HOME . '/.cache/vim/undo', 'p', 0700 )
endif

if has("persistent_undo")
    set undofile
    set undodir=~/.cache/vim/undo
endif

