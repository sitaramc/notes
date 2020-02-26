" setup for external plugins

" ----------------------------------------------------------------------
" list of plugins (as of 2019-08-21)
"       https://github.com/godlygeek/tabular.git
"       https://github.com/JuliaEditorSupport/julia-vim.git
"       https://github.com/junegunn/fzf.vim.git
"       https://github.com/junegunn/gv.vim.git
"       https://github.com/justinmk/vim-sneak.git
"       https://github.com/mbbill/undotree.git
"       https://github.com/scrooloose/nerdcommenter.git
"       https://github.com/SirVer/ultisnips.git
"       https://github.com/tpope/vim-fugitive.git
"       https://github.com/tpope/vim-surround.git
"       https://github.com/vim-scripts/DirDiff.vim.git
"       https://github.com/vim-scripts/DrawIt.git

" to update plugins:
"       ( cd /usr/local/.vim ; umask 022; find . -name .git -type d | map -n1 "cd %D; pwd; git pull; git diff --quiet ORIG_HEAD.. || gitk ORIG_HEAD.." )

" ----------------------------------------------------------------------
" plugin specific settings (including mapping changes)

     let        g:UltiSnipsEditSplit="vertical"
     let        g:UltiSnipsSnippetsDir="~/.config/usnips"
     let        g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME.'/.vim/usnips', $HOME.'/.config/usnips']
     let        g:UltiSnipsJumpForwardTrigger="<tab>"

    " the below code was picked up from ':help FZF', except we force Rg to be always fullscreen.  (Files still needs a ! to go fullscreen)
    " 2020-02-19 also add -L to follow symlinks
        command! -bang -nargs=* Rg
          \ call fzf#vim#grep(
          \   'rg -L --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
          \   fzf#vim#with_preview('up:60%'),
          \   1)
        command! -bang -nargs=? -complete=dir Files
          \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    nmap        <Leader>ht              :Helptags<CR>
    nmap        <Leader>b               :Buffers<CR>
    nmap        <Leader>m               :History<CR>
    nmap        <Leader>d               :Files<CR>
    nmap        <Leader>t               :Tags<CR>

    nmap        <Leader>S               :GFiles?<CR>
    nmap        <Leader>g               :Rg<SPACE>
    nmap        <Leader>l               :Lines<CR>

        " Insert mode completion
    imap        <c-x><c-k>              <plug>(fzf-complete-word)
  " imap        <c-x><c-f>              <plug>(fzf-complete-path)
    imap        <expr> <c-x><c-f>       fzf#vim#complete#path("fd -HI -L -E .git -E .cache")
                                        " brute force override ^X^F to use fd instead of the weak "find" hardcoded in plugin/fzf.vim
    imap        <c-x><c-l>              <plug>(fzf-complete-line)

     let        g:fzf_history_dir       = '~/.cache/fzf-history'

     let        g:DirDiffExcludes="*.pyo,.audacity-data,.bash_history,.bash_logout,.bash_profile,.cache,.cargo,.chpwd-recent-dirs,abrt,asciinema,borg,chromium,containers,dconf,dnfdragora.yaml,gconf,geany,geeqie,GIMP,gt,gtk-2.0,gtk-3.0,ibus,imsettings,kdeglobals,lftp,libreoffice,Mousepad,okular.kmessagebox,pavucontrol.ini,procps,pulse,QDirStat,QtProject.conf,ristretto,sealert.conf,session,syncthing,Thunar,transmission,user-dirs.dirs,user-dirs.locale,vidcutter,xarchiver,xfce4,xfce4-session,data,Downloads,.esd_auth,.esmtp_queue,.fltk,.gimp-2.8,.gnome2,.gnome2_private,.gphoto,.ICEauthority,.java,.julia,.lesshst,.local,.mozilla,.perl_history,.pki,.sqlite_history,.thumbnails,.viminfo,.w3m,.wget-hsts,.xscreensaver,.xsel.log,.xsession-errors,.xsession-errors.old,.zcompdump,.zsh_history,.dbus,.freemind,.gnupg,.gvfs,.kde,.keychain,.mutthistory,.recoll,.texlive*,.xauth*,.xfce4*,junk*"

     let        NERDSpaceDelims=1
    vmap        ##                      <Leader>cl
    vmap        #$                      <Leader>cu
    vmap        #i                      <Leader>ci
    vmap        #<Space>                <Leader>c<Space>
    vmap        #y                      <Leader>cy

    nmap        <Leader>a               :Tabularize /
    vmap        <Leader>a               :Tabularize /

     let        g:undotree_WindowLayout = 2
     let        g:undotree_DiffpanelHeight = 16
     let        g:undotree_SetFocusWhenToggle = 1
nnoremap        <Leader>u           :UndotreeToggle<CR>

    " in case we ever use it again
    " let        g:airline_theme_patch_func = 'AirlineThemePatch'
    "            function! AirlineThemePatch(palette)
    "                for colors in values(a:palette.inactive)
    "                    let colors[2] = 'lightblue'
    "                endfor
    "                for colors in values(a:palette.inactive_modified)
    "                    let colors[2] = 'lightblue'
    "                endfor
    "            endfunction
    " let        g:airline_section_c="%f%a%m"
    " let        g:airline_section_z="%3p%%(%L) %3l %3c%3V"
    " let        g:airline_mode_map = {
    "                \ 'n'  : 'NOR',
    "                \ 'i'  : 'INS',
    "                \ 'R'  : 'REP',
    "                \ 'v'  : 'VIS',
    "                \ 'V'  : 'V-L',
    "                \ 'c'  : 'CMD',
    "                \ '' : 'V-B',
    "            \ }

     let        g:sneak#streak = 1  " ? skips folded text
     let        g:sneak#s_next = 1
     let        g:sneak#use_ic_scs = 1
nnoremap        gb                      :Gblame<CR>
nnoremap        gc                      :Gdiff -<CR>
nnoremap        gd                      :Gdiff<CR>
nnoremap        ge                      :Gedit<CR>
nnoremap        gs                      :call Gs()<CR>
                            function! Gs()
                                Gstatus
                                resize 12
                                wincmd t
                                normal gg
                                " rats!  <C-N> doesn't work for some reason
                            endfunction
nnoremap        gW                      :Gwrite<CR>
nnoremap        gl                      :silent Glog -- %<bar>redraw!<bar>copen<CR>
nnoremap        gr                      :silent 0Glog<bar>redraw!<bar>copen<CR>
nnoremap        gL                      :GV!<CR>
nnoremap        gk                      :GV<CR>
nnoremap        gka                     :GV --all<CR>
nnoremap        g<Space>                :Git<space>

