" a few bits and pieces from https://github.com/tpope/vim-sensible

" Lowering this improves performance in files with long lines.
set synmaxcol=500

set autoread

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" <C-G>u is apparently 'break undo sequence'.  Do we need this?
" if empty(mapcheck('<C-U>', 'i'))
"   inoremap <C-U> <C-G>u<C-U>
" endif
" if empty(mapcheck('<C-W>', 'i'))
"   inoremap <C-W> <C-G>u<C-W>
" endif
