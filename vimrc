" vim: set ft=vim :

" color  {{{
highlight IncSearch    ctermbg=black    ctermfg=red     cterm=reverse
highlight Search       ctermbg=blue     ctermfg=white   cterm=none
highlight TabLine      ctermfg=black    ctermbg=black   cterm=none 
highlight TabLineSel   ctermfg=green    ctermbg=black   cterm=reverse
highlight TabLineFill  ctermfg=black
highlight Pmenu        ctermfg=white    ctermbg=blue    cterm=none
highlight PmenuSel     ctermfg=black    ctermbg=green   cterm=none
highlight PmenuSbar    ctermbg=black
highlight PmenuThumb   ctermbg=black
highlight CursorLine   ctermfg=yellow   ctermbg=black   cterm=inverse
" settings below ard used by statusline
highlight User1        ctermfg=magenta  ctermbg=black   cterm=inverse
highlight User2        ctermfg=cyan     ctermbg=black   cterm=inverse
highlight User3        ctermfg=green    ctermbg=black   cterm=inverse
highlight User4        ctermfg=yellow   ctermbg=black   cterm=inverse
highlight User5        ctermfg=blue     ctermbg=black   cterm=inverse

"}}}

let   mapleader=","
let g:mapleader=","

exec pathogen#infect()

" option  {{{
filetype plugin indent on
syntax enable
syntax on

set ambiwidth=double
set autochdir
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set completeopt=menu
set display=lastline
set diffopt=filler,context:3,foldcolumn:0
set encoding=utf-8
set expandtab
set fileencoding=chinese
set fileencodings=utf-8,gb2312,gbk,gb18030
set foldmethod=marker
set helplang=en
set hidden
set hlsearch
set history=64
set ignorecase
set incsearch
set keywordprg=
set lazyredraw
set laststatus=2
set linebreak
set magic
set modeline
set mouse=
set nobackup
set nocompatible
set nocursorline
set noerrorbells
set noshowmatch
set nostartofline
set noswapfile
set nowrap
set nocursorline
set numberwidth=1
set ruler
set scrolloff=0
set selection=inclusive
set shiftwidth=4
set showcmd
set smartcase
set smartindent
set smarttab
set softtabstop=4
set statusline=%{MyColorStatusLine()}
set tabstop=4
set tags=tags;
set termencoding=utf-8
set textwidth=0
set wildmenu
set wildignorecase
"}}}

" mapping  {{{
map <F5>   :call CompileRunGcc()<CR>
map <F6>   :call Rungdb()<CR>
map <F7>   :set wrap!<CR>
map <F8>   :nohlsearch<CR>

cnoremap   <C-A>    <Home>
cnoremap   <C-B>    <Left>
cnoremap   <C-D>    <Del>
cnoremap   <C-E>    <End>
cnoremap   <C-F>    <Right>
inoremap   <C-A>    <Home>
inoremap   <C-B>    <Left>
inoremap   <C-D>    <Del>
inoremap   <C-F>    <Right>
inoremap   <C-L>    <END>
inoremap   <C-H>    <BS>
inoremap   <C-K>    <Esc>lC
inoremap   <Tab>    <C-N>
nnoremap   <BS>     <Nop>
nnoremap   <C-H>    <C-^>
nnoremap   <Space>  <PageDown>
nnoremap   <C-J>    <PageDown>
nnoremap   <C-K>    <PageUp>
nnoremap   <C-N>    :bn<CR>
nnoremap   <C-P>    :bp<CR>
"inoremap   <C-Y>    <C-R><C-R>=LookupColumnChar('y')<CR>
"inoremap   <C-E>    <C-R><C-R>=LookupColumnChar('e')<CR>

"onoremap   if   :normal [[jV]]k<CR>
"onoremap   af   :normal [[v%<CR>

"vnoremap  #   y:let @/=@"<CR>N
"vnoremap  *   y/<C-R>"<CR>
nnoremap   '   `
nnoremap   ['  [`
nnoremap   ]'  ]`
nnoremap   0   ^
nnoremap   #   #n
nnoremap  g#   g#n
nnoremap   *   *N
nnoremap  g*   g*N
vnoremap   #   y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap   *   y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap   <   <gv
vnoremap   >   >gv

nnoremap  cd   :cd 
nnoremap  c.   :cc<CR>
nnoremap  ch   :colder<CR>
nnoremap  cl   :cnewer<CR>
nnoremap  cj   :cnext<CR>
nnoremap  ck   :cprev<CR>
nnoremap  cn   :cnext<CR>
nnoremap  cp   :cprev<CR>
nnoremap  co   :call SmartOpenQfWin()<CR>
nnoremap  c<space>  :call SmartOpenQfWin()<CR>

if &diff
syntax    off
nnoremap  dj   ]c
nnoremap  dk   [c
nnoremap  dn   ]c
nnoremap  dp   [c
nnoremap  di   :diffget<CR>
vnoremap  di   :diffget<CR>
nnoremap  do   :diffput<CR>
vnoremap  do   :diffput<CR>
nnoremap  du   :diffupdate<CR>
endif
nnoremap  d<space>  :call SmartDiffOff()<CR>

nnoremap  gj   J
nnoremap  gw   :write<CR>
nnoremap  gW   :w !sudo tee % > /dev/null<CR>
nnoremap  g/   :Ag  %<left><left>
nnoremap  j    gj
vnoremap  j    gj
nnoremap  k    gk
vnoremap  k    gk
nnoremap  J    <C-E>
nnoremap  K    <C-Y>
nnoremap  q    :call SmartQuit()<CR>
nnoremap  Q    :qall<CR>
nnoremap  S    :%s//g<Left><Left>
vnoremap  S    :s/\%V/g<left><left>
nnoremap  s    <C-W>
vnoremap  s    <C-W>
nnoremap  sa   :ball<CR>
nnoremap  s}   :call OpenTagPreviewWin()<CR>
nnoremap  s*   :call ListSrchCurrFile("n")<CR>
vnoremap  s*   y:call ListSrchCurrFile("v")<CR>
nnoremap  s/   :vimgrep  %<left><left>
nnoremap  s?   :vimgrepadd  %<left><left>
nnoremap  U    <C-R>
nnoremap  Y    y$
nnoremap  vo   o<Esc>k
nnoremap  vO   O<Esc>j
nnoremap  zo   @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
nnoremap  z<space>  @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
nnoremap  s<space>  :call SmartWinMax()<CR>
nnoremap  t<space>  :TlistToggle<CR>

nnoremap  <leader>be   :BufExplorer<CR>
nnoremap  <leader>fe   :EditVifm<CR>
nnoremap  <leader>tl   :TlistToggle<CR>
nnoremap  <leader>ct   :ConqueTerm bash<CR>
nnoremap  <leader>vm   :VimuxPromptCommand<CR>
nnoremap  <leader>te   :tabedit <C-R>=expand("%:p:h")<CR>/
nnoremap  <leader>cd   :cd %:p:h<CR>:pwd<CR>
nnoremap  <leader>md   :!Markdown.pl % > %.html<CR><CR>:!w3m %.html<CR>
nnoremap  <leader>ts   :%s/\t/    /g<CR>
"}}}

" abbrev  {{{
iabbrev   teh      the
iabbrev   xbq      `
iabbrev   xdate    <C-R>=strftime("%d/%m/%y %H:%M:%S")<cr>
cabbrev   xcal     Calendar<cr>
"}}}

" function  {{{
func! MyQfSettings()
    call MyColorStatusLine()

    nnoremap <buffer> <silent> i <cr>
    nnoremap <buffer> <silent> o <cr>zz:wincmd p<cr>
    nnoremap <buffer> <silent> <space> <cr>zz:wincmd p<cr>
endfunc

func! MyTaglistSettings()
    nnoremap <buffer> <silent> s <C-W>
endfunc

func! MyColorStatusLine()
    highlight VertSplit    ctermfg=red     ctermbg=black   cterm=none

    set fillchars=vert:\|
    set statusline=%2*\#%n@%{len(ListedBufs())}%0*\ %3*[%{strlen(&ft)?&ft:'none'}]
    set statusline+=%r%m%0*\ %4*%<\"%F\"%0*\ %2*%=%0*\ %4*%4l/%-4L%0*\ %2*--%p%%--%0*
endfunc

func! MyPlainStatusLine()
    highlight StatusLine   ctermfg=green   ctermbg=black   cterm=none
    highlight StatusLineNC ctermfg=green   ctermbg=black   cterm=none
    highlight VertSplit    ctermfg=green   ctermbg=black   cterm=none

    set fillchars=vert:\|,stl:=,stlnc:-
    set statusline=
endfunc

func! ListedBufs()
    return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunc

func! SmartQuit()
    if &diff
        qall
        return
    endif

    if len(ListedBufs()) == 1
        quit
        return
    endif

    if winnr("$") == 1
        bdelete
        return
    endif

    let l:wincnt = 0
    let l:curbufnr = winbufnr(0)
    for w in range(1, winnr('$'))
        if winbufnr(w) == l:curbufnr
            let l:wincnt = l:wincnt + 1
        endif
    endfor

    if l:wincnt > 1
        quit
        return
    endif

    if bufname('%') ==# "[Command Line]"
        quit
        return
    endif

    bdelete
endfunc

func! DelEmptyFile()
    for b in ListedBufs()
        if empty(bufname(b)) && getbufvar(b, "&filetype") != "man"
            exec "bdelete ".b
            break
        endif
    endfor
endfunc

func! DelHelpFile()
    for b in ListedBufs()
        if getbufvar(b, "&buftype") == "help"
            exec("bdelete ".b)
        endif
    endfor
endfunc

func! LineStrip()
    exec "normal mz"
    %s/\s\+$//ge
    exec "normal `z"
endfunc

func! SmartOpenQfWin()
    wincmd b
    if &filetype == "qf"
        wincmd p
        cclose
    else
        wincmd p
        copen
    endif
endfunc

func! OpenTagPreviewWin()
    if &previewwindow
        return
    endif

    let w = expand("<cword>")
    if w !~ '\a'
        " If w is not letters, do nothing
        return
    endif

    " Delete any existing highlight before showing another tag
    silent! wincmd P
    if &previewwindow
        match none
        wincmd p
    endif

    " Try displaying a matching tag for the word under the cursor
    try
        exec "ptag " . w
    catch
        return
    endtry

    silent! wincmd P
    if &previewwindow
	   if has("folding")
	       silent! .foldopen
	   endif

	   call search("$", "b")
	   let w = substitute(w, '\\', '\\\\', "")
	   call search('\<\V' . w . '\>')

	   " Add a match highlight to the word at this position
       hi previewWord term=bold ctermbg=blue guibg=green
	   exec 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'

       wincmd p
    endif
endfunc

func! ListSrchCurrFile(mode)
    if a:mode == "n"
        let w = expand("<cword>")
    elseif a:mode == "v"
        let w = escape(@", '\\/.*$^~[]')
    else
        return
    endif

    if w !~ '\a'
        return
    endif

    let save_cursor = getpos(".")
    exec 'vimgrep '. shellescape(w) . ' %'
    copen
    wincmd p
    call setpos('.', save_cursor)
endfunc

func! SmartDiffOff()
    if &diff
        diffoff
    else
        windo diffthis
    endif
endfunc

let g:WinMaxFlag = 0
func! SmartWinMax()
    if g:WinMaxFlag == 0
        wincmd _
        wincmd |
        let g:WinMaxFlag = 1
    else
        wincmd =
        let g:WinMaxFlag = 0
    endif
endfunc

func! LookupColumnChar(mode)
    let cnum = virtcol('.')
    let cpat = '\%'. cnum. 'v.'
    if a:mode ==? 'y'
        let flag = 'bnW'
    else
        let flag = 'nW'
    endif

    let lnum = search(cpat. '*\S', flag)
    if lnum == 0
        return ""
    endif

    return matchstr(getline(lnum), cpat)
endfunc

func! CompileRunGCC()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'mkd'
        exec "!Markdown.pl % > %.html &"
        "exec "!firefox %.html &"
    endif
endfunc

func! RunGDB()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc

""定义函数SetTitle，自动插入文件头 
func! SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1,"\#!/bin/bash") 
        call append(line("."), "") 
    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python")
        call append(line("."),"# coding=utf-8")
        call append(line(".")+1, "") 
    else 
        call setline(1, "/*************************************************************************") 
        call append(line("."),   "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: ma6174") 
        call append(line(".")+2, "    > Mail: ma6174@163.com ") 
        call append(line(".")+3, "    > Created Time: ".strftime("%c")) 
        call append(line(".")+4, " ************************************************************************/") 
        call append(line(".")+5, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+6, "#include <iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif
    if &filetype == 'c'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "")
    endif
endfunc 
"}}}

" autocmd  {{{
augroup autocmds
    autocmd!

    autocmd FileType * setlocal formatoptions-=ro formatoptions+=j cedit=<C-O>

    "进入文件后定位到上次退出时的位置
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exec "normal! g`\"" | endif

    "custom quickfix window statusline
    autocmd FileType qf call MyQfSettings()

    autocmd BufReadPost taglist call MyTaglistSettings()

    "preserve window view when switching buffers
    autocmd BufLeave * if !&diff | let b:winview = winsaveview() | endif
    autocmd BufEnter * if !&diff && exists('b:winview') | call winrestview(b:winview) | endif

    "set help file listed
    autocmd FileType help set buflisted

    "when reading man file, delete empty file
    autocmd FileType man,help call DelEmptyFile()

    "syntax highlight for txt file (txt.vim is needed)
    autocmd BufNewFile,BufRead *.txt set filetype=txt
    autocmd FileType changelog set filetype=txt

    "auto load vimrc after writing
    "autocmd BufWritePost .vimrc source ~/.vimrc

    "reading Ms-Word documents, requires antiword
    autocmd BufReadPre  *.doc setlocal readonly
    autocmd BufReadPost *.doc %!antiword "%"

    "Delete trailing white space on save
    "autocmd BufWrite *.py call LineStrip()

    "自动将Vim工作目录迁移到所打开文件的目录下
    "autocmd BufEnter * cd %:p:h

    "au FileType php setlocal dict+=~/.vim/dict/php_funclist.dict
    "au FileType css setlocal dict+=~/.vim/dict/css.dict
    "au FileType c setlocal dict+=~/.vim/dict/c.dict
    "au FileType cpp setlocal dict+=~/.vim/dict/cpp.dict
    "au FileType scale setlocal dict+=~/.vim/dict/scale.dict
    "au FileType javascript setlocal dict+=~/.vim/dict/javascript.dict
    "au FileType html setlocal dict+=~/.vim/dict/javascript.dict
    "au FileType html setlocal dict+=~/.vim/dict/css.dict
augroup END
"}}}

" command  {{{
" See the difference between the current buffer and the file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

command! Rcvim   edit  ~/.vimrc
command! Rcvifm  edit  ~/.vifm/vifmrc
command! Rcw3m   edit  ~/.w3m/keymap
command! Rctmux  edit  ~/.tmux.conf
command! Xhelp   call  DelHelpFile()
command! Xsrc    source ~/.vimrc
"}}}

" plugins  {{{
"Ag {{{
let g:ag_prg="ag --vimgrep --smart-case"
"}}}

"BufExplorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerSortBy='mru'
let g:bufExplorerSplitBelow=0        " Split new window above current.
"}}}

"pandoc {{{
let g:pandoc#folding#fdc=0
let g:pandoc#filetypes#pandoc_markdown=0
"}}}

"taglist {{{
let  g:Tlist_Auto_Update = 1
let  g:Tlist_Auto_Highlight_Tag = 1
let  g:Tlist_Show_One_File = 1
let  g:Tlist_Exit_OnlyWindow = 1
let  g:Tlist_GainFocus_On_ToggleOpen = 1
"}}}

"neocomplcache {{{
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 3
"}}}

"vimwiki {{{
"let g:vimwiki_use_mouse = 0
"let g:vimwiki_camel_case = 0
"let g:vimwiki_html_header_numbering = 2
"let g:vimwiki_hl_cb_checked = 1
"let g:vimwiki_CJK_length = 1
"let g:vimwiki_list = [{'path':'~/vimwiki/', 'path_html':'~/vimwiki/html/'}]
"}}}

"conque-term {{{
"}}}

"w3m {{{
"let g:w3m#hover_set_on = -1
"let g:w3m#hover_delay_time = 50
"let g:w3m#external_browser = 'w3m'
"let g:w3m#homepage = 'http://www.baidu.com'
"let g:w3m#hit_a_hint_key = 'f'
"}}}

"viewdoc {{{
let g:viewdoc_open = "topleft new"
let g:viewdoc_only = 0
"}}}

"CtrlP {{{
let g:ctrlp_map = '<c-;>'
"}}}

"markdown {{{
let g:vim_markdown_folding_disabled=1
"}}}

"delimitMate {{{
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 2
"}}}

"shot-f {{{
let g:shot_f_no_default_key_mappings = 1
"nmap f  <Plug>(shot-f-f)
"nmap F  <Plug>(shot-f-F)
"xmap f  <Plug>(shot-f-f)
"xmap F  <Plug>(shot-f-F)
"omap f  <Plug>(shot-f-f)
"omap F  <Plug>(shot-f-F)
"omap t  <Plug>(shot-f-t)
"omap T  <Plug>(shot-f-T)
"}}}

"tmux-navigator {{{
let g:tmux_navigator_save_on_switch = 0
let g:tmux_navigator_no_mappings = 1
"}}}
"}}}
