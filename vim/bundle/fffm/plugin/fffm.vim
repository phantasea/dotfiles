" fffm.vim

if exists('g:loaded_fffm')
	finish
endif
let g:loaded_fffm = 1

command! -nargs=* -complete=dir Fffm call fffm#Run(<q-args>)
