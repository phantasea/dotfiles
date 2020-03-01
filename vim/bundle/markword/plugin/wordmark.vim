" Script Name: markword.vim
" Version:     1.1.8 (global version)
" Last Change: April 25, 2008
" Author:      Yuheng Xie <elephant@linux.net.cn>
" Contributor: Luc Hermitte

if exists('g:loaded_markword')
	finish
endif
let g:loaded_markword = 1

" Support for |line-continuation|
let s:save_cpo = &cpo
set cpo&vim

let s:current_mark_position = ""

" default colors/groups
" you may define your own colors in you vimrc file, in the form as below:
hi MarkWord1  cterm=bold ctermbg=Cyan     ctermfg=White  guibg=#8CCBEA    guifg=Black
hi MarkWord2  cterm=bold ctermbg=Green    ctermfg=White  guibg=#A4E57E    guifg=Black
hi MarkWord3  cterm=bold ctermbg=Yellow   ctermfg=White  guibg=#FFDB72    guifg=Black
hi MarkWord4  cterm=bold ctermbg=Red      ctermfg=White  guibg=#FF7272    guifg=Black
hi MarkWord5  cterm=bold ctermbg=Magenta  ctermfg=White  guibg=#FFB3FF    guifg=Black
hi MarkWord6  cterm=bold ctermbg=White    ctermfg=Black  guibg=#9999FF    guifg=Black

" Default bindings

if !hasmapto('<Plug>MarkWord', 'n')
	nmap <unique> <silent> mw <Plug>MarkSet
endif
if !hasmapto('<Plug>MarkWord', 'v')
	vmap <unique> <silent> mw <Plug>MarkSet
endif
if !hasmapto('<Plug>MarkClear', 'n')
	nmap <unique> <silent> mW <Plug>MarkClear
endif

nnoremap <silent> <Plug>MarkSet   :call <sid>MarkCurrentWord()<cr>
vnoremap <silent> <Plug>MarkSet   <c-\><c-n>:call <sid>DoMark(<sid>GetVisualSelectionEscaped("enV"))<cr>
nnoremap <silent> <Plug>MarkClear :call <sid>DoMark()<cr>
"nnoremap <silent> <Plug>MarkClear :call <sid>DoMark(<sid>CurrentMark())<cr>

nnoremap <silent> <unique> <F3> :call <sid>SearchCurrentMark()<cr>
nnoremap <silent> <unique> <F4> :call <sid>SearchCurrentMark("b")<cr>
"nnoremap <silent> <leader>/ :call <sid>SearchAnyMark()<cr>
"nnoremap <silent> <leader>? :call <sid>SearchAnyMark("b")<cr>
"nnoremap <silent> * :if !<sid>SearchNext()<bar>execute "norm! *"<bar>endif<cr>
"nnoremap <silent> # :if !<sid>SearchNext("b")<bar>execute "norm! #"<bar>endif<cr>

command! -nargs=? Mark call s:DoMark(<f-args>)

autocmd! BufWinEnter * call s:UpdateMark()

function! s:MarkCurrentWord()
	let w = s:PrevWord()
	if w != ""
		call s:DoMark('\<' . w . '\>')
	endif
endfunction

function! s:GetVisualSelection()
	let save_a = @a
	silent normal! gv"ay
	let res = @a
	let @a = save_a
	return res
endfunction

function! s:GetVisualSelectionEscaped(flags)
	" flags:
	"  "e" \  -> \\  
	"  "n" \n -> \\n  for multi-lines visual selection
	"  "N" \n removed
	"  "V" \V added   for marking plain ^, $, etc.
	let result = s:GetVisualSelection()
	let i = 0
	while i < strlen(a:flags)
		if a:flags[i] ==# "e"
			let result = escape(result, '\')
		elseif a:flags[i] ==# "n"
			let result = substitute(result, '\n', '\\n', 'g')
		elseif a:flags[i] ==# "N"
			let result = substitute(result, '\n', '', 'g')
		elseif a:flags[i] ==# "V"
			let result = '\V' . result
		endif
		let i = i + 1
	endwhile
	return result
endfunction

" define variables if they don't exist
function! s:InitMarkVariables()
	if !exists("g:mwHistAdd")
		let g:mwHistAdd = "/@"
	endif
	if !exists("g:mwCycleMax")
		let i = 1
		while hlexists("MarkWord" . i)
			let i = i + 1
		endwhile
		let g:mwCycleMax = i - 1
	endif
	if !exists("g:mwCycle")
		let g:mwCycle = 1
	endif
	let i = 1
	while i <= g:mwCycleMax
		if !exists("g:mwWord" . i)
			let g:mwWord{i} = ""
		endif
		let i = i + 1
	endwhile
	if !exists("g:mwLastSearched")
		let g:mwLastSearched = ""
	endif
endfunction

" return the word under or before the cursor
function! s:PrevWord()
	let line = getline(".")
	if line[col(".") - 1] =~ '\w'
		return expand("<cword>")
	else
		return substitute(strpart(line, 0, col(".") - 1), '^.\{-}\(\w\+\)\W*$', '\1', '')
	endif
endfunction

" mark or unmark a regular expression
function! s:DoMark(...)
	" define variables if they don't exist
	call s:InitMarkVariables()

	" clear all marks if regexp is null
	let regexp = ""
	if a:0 > 0
		let regexp = a:1
	endif
	if regexp == ""
		let i = 1
		while i <= g:mwCycleMax
			if g:mwWord{i} != ""
				let g:mwWord{i} = ""
				let lastwinnr = winnr()
				exe "windo syntax clear MarkWord" . i
				exe lastwinnr . "wincmd w"
			endif
			let i = i + 1
		endwhile
		let g:mwLastSearched = ""
		return 0
	endif

	" clear the mark if it has been marked
	let i = 1
	while i <= g:mwCycleMax
		if regexp == g:mwWord{i}
			if g:mwLastSearched == g:mwWord{i}
				let g:mwLastSearched = ""
			endif
			let g:mwWord{i} = ""
			let lastwinnr = winnr()
			exe "windo syntax clear MarkWord" . i
			exe lastwinnr . "wincmd w"
			return 0
		endif
		let i = i + 1
	endwhile

	" quote regexp with / etc. e.g. pattern => /pattern/
	let quote = "/?~!@#$%^&*+-=,.:"
	let i = 0
	while i < strlen(quote)
		if stridx(regexp, quote[i]) < 0
			let quoted_regexp = quote[i] . regexp . quote[i]
			break
		endif
		let i = i + 1
	endwhile
	if i >= strlen(quote)
		return -1
	endif

	" choose an unused mark group
	let i = 1
	while i <= g:mwCycleMax
		if g:mwWord{i} == ""
			let g:mwWord{i} = regexp
			if i < g:mwCycleMax
				let g:mwCycle = i + 1
			else
				let g:mwCycle = 1
			endif
			let lastwinnr = winnr()
			exe "windo syntax clear MarkWord" . i
			" suggested by Marc Weber
			" exe "windo syntax match MarkWord" . i . " " . quoted_regexp . " containedin=ALL"
			exe "windo syntax match MarkWord" . i . " " . quoted_regexp . " containedin=.*"
			exe lastwinnr . "wincmd w"
			return i
		endif
		let i = i + 1
	endwhile

	" choose a mark group by cycle
	let i = 1
	while i <= g:mwCycleMax
		if g:mwCycle == i
			if g:mwLastSearched == g:mwWord{i}
				let g:mwLastSearched = ""
			endif
			let g:mwWord{i} = regexp
			if i < g:mwCycleMax
				let g:mwCycle = i + 1
			else
				let g:mwCycle = 1
			endif
			let lastwinnr = winnr()
			exe "windo syntax clear MarkWord" . i
			" suggested by Marc Weber
			" exe "windo syntax match MarkWord" . i . " " . quoted_regexp . " containedin=ALL"
			exe "windo syntax match MarkWord" . i . " " . quoted_regexp . " containedin=.*"
			exe lastwinnr . "wincmd w"
			return i
		endif
		let i = i + 1
	endwhile
endfunction

" update mark colors
function! s:UpdateMark()
	" define variables if they don't exist
	call s:InitMarkVariables()

	let i = 1
	while i <= g:mwCycleMax
		exe "syntax clear MarkWord" . i
		if g:mwWord{i} != ""
			" quote regexp with / etc. e.g. pattern => /pattern/
			let quote = "/?~!@#$%^&*+-=,.:"
			let j = 0
			while j < strlen(quote)
				if stridx(g:mwWord{i}, quote[j]) < 0
					let quoted_regexp = quote[j] . g:mwWord{i} . quote[j]
					break
				endif
				let j = j + 1
			endwhile
			if j >= strlen(quote)
				continue
			endif

			" suggested by Marc Weber
			" exe "syntax match MarkWord" . i . " " . quoted_regexp . " containedin=ALL"
			exe "syntax match MarkWord" . i . " " . quoted_regexp . " containedin=.*"
		endif
		let i = i + 1
	endwhile
endfunction

" return the mark string under the cursor. multi-lines marks not supported
function! s:CurrentMark()
	" define variables if they don't exist
	call s:InitMarkVariables()

	let line = getline(".")
	let i = 1
	while i <= g:mwCycleMax
		if g:mwWord{i} != ""
			let start = 0
			while start >= 0 && start < strlen(line) && start < col(".")
				let b = match(line, g:mwWord{i}, start)
				let e = matchend(line, g:mwWord{i}, start)
				if b < col(".") && col(".") <= e
					let s:current_mark_position = line(".") . "_" . b
					return g:mwWord{i}
				endif
				let start = e
			endwhile
		endif
		let i = i + 1
	endwhile
	return ""
endfunction

" search current mark
function! s:SearchCurrentMark(...)
	let flags = ""
	if a:0 > 0
		let flags = a:1
	endif
	let w = s:CurrentMark()
	if w != ""
		let p = s:current_mark_position
		call search(w, flags)
		call s:CurrentMark()
		if p == s:current_mark_position
			call search(w, flags)
		endif
		let g:mwLastSearched = w
	else
		if g:mwLastSearched != ""
			call search(g:mwLastSearched, flags)
		else
			call s:SearchAnyMark(flags)
			let g:mwLastSearched = s:CurrentMark()
		endif
	endif
endfunction

" combine all marks into one regexp
function! s:AnyMark()
	" define variables if they don't exist
	call s:InitMarkVariables()

	let w = ""
	let i = 1
	while i <= g:mwCycleMax
		if g:mwWord{i} != ""
			if w != ""
				let w = w . '\|' . g:mwWord{i}
			else
				let w = g:mwWord{i}
			endif
		endif
		let i = i + 1
	endwhile
	return w
endfunction

" search any mark
function! s:SearchAnyMark(...) " SearchAnyMark(flags)
	let flags = ""
	if a:0 > 0
		let flags = a:1
	endif
	let w = s:CurrentMark()
	if w != ""
		let p = s:current_mark_position
	else
		let p = ""
	endif
	let w = s:AnyMark()
	call search(w, flags)
	call s:CurrentMark()
	if p == s:current_mark_position
		call search(w, flags)
	endif
	let g:mwLastSearched = ""
endfunction

" search last searched mark
function! s:SearchNext(...) " SearchNext(flags)
	let flags = ""
	if a:0 > 0
		let flags = a:1
	endif
	let w = s:CurrentMark()
	if w != ""
		if g:mwLastSearched != ""
			call s:SearchCurrentMark(flags)
		else
			call s:SearchAnyMark(flags)
		endif
		return 1
	else
		return 0
	endif
endfunction

" Restore previous 'cpo' value
let &cpo = s:save_cpo

" vim: ts=2 sw=2
