" from https://vimways.org/2018/colder-quickfix-lists/
" also see (.vim)/after/ftplugin/qf.vim

function! quickfixed#history(goNewer)
  " Get dictionary of properties of the current window
  let wininfo = filter(getwininfo(), {i,v -> v.winnr == winnr()})[0]
  let isloc = wininfo.loclist
  " Build the command: one of colder/cnewer/lolder/lnewer
  let cmd = (isloc ? 'l' : 'c') . (a:goNewer ? 'newer' : 'older')
  try | execute cmd | catch | endtry
endfunction
