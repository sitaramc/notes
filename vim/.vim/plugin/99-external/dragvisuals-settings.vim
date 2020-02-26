" highlight the 81st column of wide lines (he uses magenta, uggh!)
" 2014-05-21 commented out because it slows down vim TERRIBLY!
" highlight ColorColumn cterm=underline gui=underline ctermbg=NONE guibg=NONE
" call matchadd('ColorColumn', '\%81v', 100)

" help: <Leader><arrow key>         (drag visual using arrow keys)
" drag visual blocks around
vmap  <expr>  <Leader><LEFT>   DVB_Drag('left')
vmap  <expr>  <Leader><RIGHT>  DVB_Drag('right')
vmap  <expr>  <Leader><DOWN>   DVB_Drag('down')
vmap  <expr>  <Leader><UP>     DVB_Drag('up')
vmap  <expr>  <Leader>D        DVB_Duplicate()
" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1
