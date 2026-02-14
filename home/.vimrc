set clipboard^=unnamed,unnamedplus

fu! Fzy(choice_command, vim_command)
  try
    let output = system(a:choice_command . " | fzy ")
    exec a:vim_command . ' ' . output
  catch /Vim:Interrupt/
    " Swallow errors from ^C
  endtry
  redraw!
endf

com! -complete=dir -nargs=1 Fd call Fzy("fd . " . <q-args> . " -t f", ":e")

nnoremap <space>f :Fd<space>
