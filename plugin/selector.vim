" SELECTOR.vim
"
" Selecta functions:
" - buffer search
" - file search
" - grep (with the help of findrepo)
"
" To set your grepprg to findrepo from this plugin use:
" set grepprg=findrepo
"
" Credits:
" https://github.com/garybernhardt/selecta
" https://github.com/michaelavila/selecta.vim
" https://github.com/pixelb/scripts/blob/master/scripts/findrepo
"
" Installation:
" - use vim-plug / pathogen / vundle / neobundle
"
" Please also install:
" http://github.com/bogado/file-line

let s:path = expand('<sfile>:p:h')

" Functions
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | " . s:path . "/./selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    redraw! " Swallow ^C (needed to not leave garbage on screen)
    return
  endtry
  redraw!
  if selection != ''
    exec a:vim_command . " " . selection
  endif
endfunction

function! SelectaGrep(search)
  try
    let filepath = system(s:path . "/./selecta-find " . a:search)
  catch /Vim:Interrupt/
    redraw!
    return
  endtry
  redraw!
  if filepath != ''
    exec 'e ' . filepath
  endif
endfunction

function! SelectaFromList(choices, selecta_args, vim_command)
  let non_blank_choices = filter(a:choices, 'v:val !=""')
  call SelectaCommand('echo "' . escape(join(non_blank_choices, "\n"), '"') . '"', a:selecta_args, a:vim_command)
endfunction

function! SelectaBuffer()
  let bufnrs = filter(range(1, bufnr("$")), 'buflisted(v:val)')
  let buffers = map(bufnrs, 'bufname(v:val)')
  call SelectaFromList(buffers, "", ":b")
endfunction

" Mappings
command! -nargs=? SelectaGrep :call SelectaGrep(<f-args>)
nnoremap <leader>f :call SelectaCommand("find * -type f", "", ":e")<cr>
nnoremap <leader>x :call SelectaBuffer()<cr>
