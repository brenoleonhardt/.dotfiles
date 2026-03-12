set clipboard^=unnamed,unnamedplus
set autochdir
set wildmenu
set wildmode=longest:full,full
set listchars=tab:»\ ,trail:¬,lead:·,nbsp:␣,extends:›,precedes:‹
set list

fu! Fzy(choice_command, vim_command)
  try
    let output = system(a:choice_command . " | fzy ")
    exec a:vim_command . ' ' . output
  catch /Vim:Interrupt/
    " Swallow errors from ^C
  endtry
  redraw!
endf

com! -complete=dir -nargs=* Fd call Fzy("fd " . <q-args>, ":e")

nnoremap <space>f :Fd<space>

inoremap jk <esc>
inoremap kj <esc>


" ============================================================
" Emacs-style keybindings in Insert mode
" ============================================================

inoremap <C-f> <C-o>l
inoremap <C-b> <C-o>h

inoremap <M-f> <C-o>e
inoremap <M-b> <C-o>b

inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$

inoremap <C-n> <C-o>j
inoremap <C-p> <C-o>k

inoremap <M-a> <C-o>(
inoremap <M-e> <C-o>)

inoremap <M-{> <C-o>{
inoremap <M-}> <C-o>}

inoremap <M-<> <C-o>gg
inoremap <M->> <C-o>G

" goto line
inoremap <M-g>g <C-o>:

inoremap <C-d> <Del>
inoremap <M-d> <C-o>dw
inoremap <M-BS> <C-w>
inoremap <C-u> <C-o>d0
inoremap <C-k> <C-o>D
inoremap <C-/> <C-o>u

inoremap <A-j> <C-o>:m .+1<CR>
inoremap <A-k> <C-o>:m .-2<CR>

" ------------------------------------------------------------
" Movement
" ------------------------------------------------------------

cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

cnoremap <M-f> <S-Right>
cnoremap <M-b> <S-Left>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" ------------------------------------------------------------
" Deletion
" ------------------------------------------------------------

cnoremap <C-d> <Del>
cnoremap <M-d> <C-Right><C-w>
cnoremap <M-BS> <C-w>
cnoremap <C-u> <C-e><C-u>

" ------------------------------------------------------------
" History navigation
" ------------------------------------------------------------

cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" ------------------------------------------------------------
" Miscellaneous
" ------------------------------------------------------------

cnoremap <C-t> <C-e><BS>
cnoremap <C-l> <C-f>
