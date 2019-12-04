" vim: set ft=vim :

" colorscheme  {{{
highlight Search       ctermbg=blue     ctermfg=white   cterm=bold
highlight IncSearch    ctermbg=red      ctermfg=white   cterm=bold
highlight ColorColumn  ctermfg=white    ctermbg=green   cterm=bold
highlight CursorColumn ctermfg=white    ctermbg=red     cterm=bold
highlight CursorLine   ctermfg=white    ctermbg=red     cterm=bold
highlight Pmenu        ctermfg=white    ctermbg=blue    cterm=none
highlight PmenuSel     ctermfg=black    ctermbg=green   cterm=none
highlight PmenuSbar    ctermbg=black
highlight PmenuThumb   ctermbg=black
highlight TabLine      ctermfg=white    ctermbg=blue    cterm=bold
highlight TabLineSel   ctermfg=white    ctermbg=green   cterm=bold
highlight TabLineFill  ctermfg=white    ctermbg=blue    cterm=bold
" settings below are used by statusline
highlight User1        ctermfg=magenta  ctermbg=black   cterm=inverse
highlight User2        ctermfg=cyan     ctermbg=black   cterm=inverse
highlight User3        ctermfg=green    ctermbg=black   cterm=inverse
highlight User4        ctermfg=yellow   ctermbg=black   cterm=inverse
highlight User5        ctermfg=blue     ctermbg=black   cterm=inverse

"}}}

let   mapleader=","
let g:mapleader=","

exec pathogen#infect()

runtime ftplugin/man.vim

set rtp+=~/.fzf

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
set cursorline
set diffopt=internal,indent-heuristic,filler,vertical,context:3,foldcolumn:0
set encoding=utf-8
set expandtab
set fileencoding=chinese
set fileencodings=utf-8,gb2312,gbk,gb18030
set foldmethod=manual
set grepprg=ag\ --nogroup\ --nocolor\ --smart-case
set helplang=en
set hidden
set hlsearch
set history=64
set ignorecase
set incsearch
set iskeyword-=.
set keywordprg=
set nolazyredraw
set laststatus=2
set linebreak
set list
set listchars=tab:▸\     "set listchars+=eol:¬
set magic
set modeline
set mouse=a
set nobackup
set nocompatible
set nocursorcolumn
set noerrorbells
set noshowmatch
set nostartofline
set noswapfile
set nowrap
set nrformats=hex
set numberwidth=1
set ruler
set scrolloff=0
set selection=inclusive
set shiftwidth=4
set showcmd
set showtabline=1
set smartcase
set smartindent
set smarttab
set softtabstop=4
set statusline=%{MyColorStatusLine()}
set tabstop=4
set tags=tags;
set termencoding=utf-8
set textwidth=0
set ttyfast
set updatetime=2000
set viminfo='49,<0,s10,h,/25,f0,n~/.vim/viminfo
set wildmenu
set wildmode=full
set wildignorecase
if &term =~ '256color'
    set t_Co=256
    set t_ut=
endif
"}}}

" mapping  {{{
inoremap   <Tab>      <C-N>
nnoremap  g<Tab>      :retab<CR>
nnoremap   <CR>       <C-W>w
nnoremap   <BS>       <PageUp>H
nnoremap   <Space>    <PageDown>L
nnoremap   <Up>       <C-Y>
nnoremap   <Down>     <C-E>
nnoremap   <Left>     zh
nnoremap   <S-Left>   zH
nnoremap   <C-Left>   zs
nnoremap   <Right>    zl
nnoremap   <S-Right>  zL
nnoremap   <C-Right>  ze

map <F7>   :set wrap!<CR>
map <F8>   :nohlsearch<CR>

cmap  jj   <ESC>

onoremap   aa   :<C-U>normal! ggVG<CR>
onoremap   if   :<C-U>normal! [[jV]]k<CR>
onoremap   af   :<C-U>normal! [[v%<CR>

vnoremap   aa   VGo1G
vnoremap   if   <Esc>[[jV]]k
vnoremap   af   <Esc>[[v%

cnoremap   <C-A>    <Home>
cnoremap   <C-B>    <Left>
cnoremap   <C-D>    <Del>
cnoremap   <C-E>    <End>
cnoremap   <C-F>    <Right>
cnoremap   <C-O>    <S-Tab>
cnoremap   <C-Y>    <S-Left>
cnoremap   <C-G>    <S-Right>

inoremap   <C-A>    <Home>
inoremap   <C-B>    <Left>
inoremap   <C-D>    <Del>
inoremap   <C-F>    <Right>
inoremap   <C-L>    <End>
inoremap   <C-H>    <BS>
inoremap   <C-K>    <Esc>lC
inoremap   <C-Y>    <C-R><C-R>=VCopy('up')<CR>
inoremap   <C-E>    <C-R><C-R>=VCopy('down')<CR>

nnoremap   <C-E>    :FFEdit<cr>
nnoremap   <C-F>    :FFFave<cr>
nnoremap   <C-G>    :FFGrep<space>
nnoremap   <C-H>    <C-^>
nnoremap   <C-J>    <PageDown>L
vnoremap   <C-J>    <PageDown>zz
nnoremap   <C-K>    <PageUp>H
vnoremap   <C-K>    <PageUp>zz
nnoremap   <C-N>    :bn<CR>
nnoremap   <C-P>    :bp<CR>
nnoremap   <C-U>    <C-T>

"vnoremap  #    y:let @/=@"<CR>N
"vnoremap  *    y/<C-R>"<CR>
nnoremap  \|\|  \|
nnoremap   '    `
nnoremap   ['   [`
nnoremap   ]'   ]`
nnoremap   0    ^
nnoremap   &    :&&<CR>
nnoremap  g/    :Ag  %<left><left>
nnoremap   #    #n
nnoremap  g#    g#n
nnoremap   *    *N
nnoremap  g*    g*N
vnoremap   &    :&&<CR>
vnoremap   #    y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap   *    y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap   <    <gv
vnoremap   >    >gv
vnoremap   .    :normal .<CR>
vnoremap  g(   <esc>`<i(<esc>`>a)<esc>
vnoremap  g[   <esc>`<i[<esc>`>a]<esc>
vnoremap  g{   <esc>`<i{<esc>`>a}<esc>
vnoremap  g"   <esc>`<i"<esc>`>a"<esc>
vnoremap  g'   <esc>`<i'<esc>`>a'<esc>
vnoremap  g<   <esc>`<i<<esc>`>i><esc>

nnoremap   c.   :cc<CR>
nnoremap   cd   :cd 
nnoremap   ch   :colder<CR>
nnoremap   cl   :cnewer<CR>
nnoremap   cj   :cnext<CR>
nnoremap   ck   :cprev<CR>
nnoremap   cn   :cnext<CR>
nnoremap   cp   :cprev<CR>
nnoremap   co   :call SmartOpenQfWin()<CR>
nnoremap  gf    :call DirFilePicker("Normal")<CR>
nnoremap   j    gj
vnoremap   j    gj
nnoremap  gj    J
nnoremap   k    gk
vnoremap   k    gk
nnoremap  gk    K
nnoremap   J    <C-E>
nnoremap   K    <C-Y>
nnoremap   n    nzz
nnoremap   N    Nzz
nnoremap   q    :call SmartQuit()<CR>
nnoremap   Q    :qall!<CR>
nnoremap  gs    :write<CR>
nnoremap   S    :%s//g<Left><Left>
vnoremap   S    :s/\%V/g<left><left>
nnoremap   s    <C-W>
nnoremap   sa   :vert ball<CR>
nnoremap   sb   :windo set scrollbind!<CR>
nnoremap   sd   :DiffOrig<CR>
nnoremap   sf   :call DirFilePicker("HSplit")<CR>
nnoremap   sq   :call QuitAllBufButMe()<CR>
nnoremap   s}   :call OpenTagPreviewWin()<CR>
nnoremap   s#   :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap   s*   :call ListSrchCurrFile("n")<CR>
vnoremap   s*   y:call ListSrchCurrFile("v")<CR>
nnoremap   s/   :vimgrep  %<left><left>
nnoremap   s?   :vimgrepadd  %<left><left>
nnoremap   U    <C-R>
nnoremap  gw    :write<CR>
nnoremap  gW    :w !sudo tee % > /dev/null<CR>
nnoremap   Y    y$
nnoremap   yo   o<Esc>k
nnoremap   yO   O<Esc>j
nnoremap   zo   @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

nnoremap   c<space>   :call SmartOpenQfWin()<CR>
nnoremap   d<space>   :call SmartDiffToggle()<CR>
nnoremap   g<space>   :edit ~/.vimrc<CR>
nnoremap   m<space>   <NOP>
nnoremap   s<space>   :<C-U>call FZF_Files(v:count1)<cr>
nnoremap   v<space>   :view ~/.vim/bookmark<CR>
nnoremap   y<space>   :Ranger<cr>
nnoremap   z<space>   @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
nnoremap   [<space>   <NOP>
nnoremap   ]<space>   <NOP>
nnoremap   <<space>   <NOP>
nnoremap   ><space>   <NOP>
nnoremap   !<space>   <NOP>
nnoremap   @<space>   <NOP>
nnoremap   =<space>   :call SmartWinMax()<CR>
nnoremap   -<space>   :set cursorline!<CR>
nnoremap  \|<space>   :set cursorcolumn!<CR>

nnoremap   <leader><leader>  <leader>
nnoremap   <leader><space>   <NOP>

nnoremap   <leader>be   :BufExplorer<CR>
nnoremap   <leader>fe   :Ranger<CR>
nnoremap   <leader>fm   :Vifm<CR>
nnoremap   <leader>te   :tabedit <C-R>=expand("%:p:h")<CR>/
nnoremap   <leader>cd   :cd %:p:h<CR>:pwd<CR>
nnoremap   <leader>ts   :%s/\t/    /g<CR>

cnoremap   <expr>  %%   getcmdtype() == ':' ? expand('%:h').'/' : '%%'
"}}}

" function  {{{
func! SetSmartQuit()
    nnoremap <buffer> <silent> q :call SmartQuit()<CR>
endfunc

func! MyDiffSetting()
    syntax     off
    nnoremap   dj   ]c
    nnoremap   dk   [c
    nnoremap   dn   ]c
    nnoremap   dp   [c
    nnoremap   di   :diffget<CR>
    nnoremap   do   :diffput<CR>
    vnoremap   di   :diffget<CR>
    vnoremap   do   :diffput<CR>
    nnoremap   du   :diffupdate<CR>
endfunc

func! MyQfSettings()
    call MyColorStatusLine()

    nnoremap <buffer> <silent> q :call SmartQuit()<CR>
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
    set statusline+=%r%m%0*\ %4*%<\"%F\"%0*\ %2*%=%0*\ %4*\ %l/%L\ \|%c\ %0*\ %2*--%p%%--%0*
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
    if &diff && len(ListedBufs()) <=2
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

let s:file_picker = "ranger"
func! DirFilePicker(mode)
    if s:file_picker == "default"
        if a:mode == "Normal"
            exec "normal! gf"
        elseif a:mode == "HSplit"
            exec "normal! \<c-w>f"
        endif
        return
    endif

    let dircmd = ""
    let filecmd = ""
    if s:file_picker == "vifm"
        if a:mode == "Normal"
            let dircmd = "Vifm"
            let filecmd = "gf"
        elseif a:mode == "HSplit"
            let dircmd = "SplitVifm"
            let filecmd = "\<c-w>f"
        elseif a:mode == "VSplit"
            let dircmd = "VSplitVifm"
            let filecmd = "\<c-w>f"
        elseif a:mode == "Tab"
            let dircmd = "TabVifm"
            let filecmd = "\<c-w>gf"
        endif
    endif

    if s:file_picker == "ranger"
        let dircmd = "Ranger"
        let filecmd = "gf"
    endif

    if dircmd == "" || filecmd == ""
        return
    endif

    "let file = expand(getline("."))
    let file = expand("<cfile>:p")
    if isdirectory(file)
        exec dircmd." ".file
    else
        exec "normal! ".filecmd
    endif
endfunc

func! QuitAllBufButMe()
    let bufs = ListedBufs()
    if len(bufs) < 2
        return
    endif

    let me = winbufnr(0)
    for b in bufs
        if b != me
            exec("bdelete ".b)
        endif
    endfor
endfunc

func! DelEmptyFile()
    for b in ListedBufs()
        if empty(bufname(b)) && empty(getbufvar(b, "&filetype"))
            exec("bdelete ".b)
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

func! SmartDiffToggle()
    if &diff
        diffoff
    else
        windo diffthis
    endif
endfunc

let s:WinMaxFlag = 0
func! SmartWinMax()
    if s:WinMaxFlag == 0
        wincmd _
        wincmd |
        let s:WinMaxFlag = 1
    else
        wincmd =
        let s:WinMaxFlag = 0
    endif
endfunc

func! VCopy(dir)
    let column     = virtcol('.')
    let pattern    = '\%' . column . 'v.'
    let sourceline = search(pattern . '*\S', a:dir=='up' ? 'bnW' : 'nW')
    if !sourceline
        return ""
    else
        return matchstr(getline(sourceline), pattern)
    endif
endfunc

func! TrimTrailingWS()
    if search('\s\+$', 'cnw')
        :%s/\s\+$//g
    endif
endfunc

func! FZF_Files(cnt)
    let curr_file = expand("%")
    let cwd = fnamemodify(curr_file, ':p:h')
    let cmd = 'fd -t=f -d=' . a:cnt . ' . ' . cwd
   "let cmd = 'ag -g "" -f ' . cwd . ' --depth 0'

    call fzf#run({
        \ 'source': cmd,
        \ 'sink':   'e',
        \ 'options':'-m -x +s',
        \ 'window': 'enew' })
endfunc

func! FZF_MRU()
    return extend(filter(copy(v:oldfiles), "v:val !~ 'fugitive:\\|^/tmp/\\|.git/'"),
         \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunc
"}}}

" autocmd  {{{
augroup autocmds
    autocmd!

    autocmd FileType fzf set noshowmode noruler nonu
    autocmd FileType * setlocal formatoptions-=ro formatoptions+=j cedit=<C-O>

    autocmd TerminalOpen call MyPlainStatusLine()

    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline

    autocmd DiffUpdated * call MyDiffSetting()

    autocmd QuickFixCmdPost * call SmartOpenQfWin()

    "Goto last location in non-empty files
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
    "autocmd FileType man,help only
    "autocmd FileType man,help call DelEmptyFile()
    autocmd BufReadPost * call DelEmptyFile()
    autocmd FileType man,help call SetSmartQuit()

    "syntax highlight for txt file (txt.vim is needed)
    autocmd BufNewFile,BufRead *.txt set filetype=txt
    autocmd FileType changelog set filetype=txt

    "reading Ms-Word documents, requires antiword
    autocmd BufReadPre  *.doc setlocal readonly
    autocmd BufReadPost *.doc %!antiword "%"

    "auto load vimrc after writing
    "autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
"}}}

" abbrev  {{{
iabbrev  xbq      `
iabbrev  xdate    <C-R>=strftime("%d/%m/%y %H:%M:%S")<cr>
"}}}

" command  {{{
"See the difference between the current buffer and the file when it was loaded
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

"fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -nargs=? -complete=dir FFFave call fzf#run(fzf#wrap(fzf#vim#with_preview
         \({'source':'cat ~/.favedirs | sed "s#\~#$HOME#" | xargs fd -a -t=f . '.expand(<q-args>)})))

command! -nargs=? -complete=dir FFEdit call fzf#run(fzf#wrap(fzf#vim#with_preview
         \({'source':'fd -a -t=f -d=3 --size=-800k . '.expand(<q-args>)})))

command! -bang -nargs=* FFGrep call fzf#vim#grep
         \('ag --vimgrep --smart-case '.shellescape(<q-args>), 1,
         \<bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)

command! FFMRU call fzf#run({
         \ 'source':  reverse(FZF_MRU()),
         \ 'sink':    'edit',
         \ 'options': '-m -x +s',
         \ 'down':    '40%' })

command! FFMFU call fzf#run({
         \ 'source':  v:oldfiles,
         \ 'sink':    'edit',
         \ 'options': '-m -x +s',
         \ 'down':    '40%' })
"}}}

" plugins  {{{
"Ag {{{
let g:ag_prg = "ag --vimgrep --smart-case"
"}}}

"fzf {{{
let g:fzf_layout = { 'down': '~40%' }

let g:fzf_action = {
  \ 'ctrl-t':'tab split',
  \ 'ctrl-s':'split',
  \ 'ctrl-v':'vsplit' }

let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'Title'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'
"}}}

"bufexplorer {{{
let g:bufExplorerDefaultHelp = 0
let g:bufExplorerSortBy = 'mru'
let g:bufExplorerSplitBelow = 0  " Split new window above current.
"}}}

"bufferline {{{
let g:bufferline_echo = 1
let g:bufferline_separator = ' '
let g:bufferline_active_buffer_left = '*'
let g:bufferline_active_buffer_right = ' '
"}}}

"ranger {{{
let g:ranger_map_keys = 0
let g:ranger_open_new_tab = 0
let g:ranger_replace_netrw = 0
let g:ranger_command_override = 'ranger --cmd "set show_hidden=false"'
"}}}

" bclose {{{
let g:loaded_bclose = 1
" }}}

" multiple-cursurs {{{
let g:multi_cursor_exit_from_visual_mode= 1
let g:multi_cursor_exit_from_insert_mode= 1
let g:multi_cursor_use_default_mapping  = 0
let g:multi_cursor_start_word_key       = '<C-Y>'
let g:multi_cursor_select_all_word_key  = 'g<C-Y>'
let g:multi_cursor_next_key             = '<C-Y>'
let g:multi_cursor_prev_key             = '<C-P>'
let g:multi_cursor_skip_key             = '<C-U>'
let g:multi_cursor_quit_key             = '<Esc>'
nnoremap <silent> <C-C> :MultipleCursorsFind <C-R><C-W>
" }}}

"taglist {{{
let  g:Tlist_Auto_Update = 1
let  g:Tlist_Auto_Highlight_Tag = 1
let  g:Tlist_Show_One_File = 1
let  g:Tlist_Exit_OnlyWindow = 1
let  g:Tlist_GainFocus_On_ToggleOpen = 1
"}}}

"nerdtree {{{
let NERDTreeIgnore=['\~$', '^lost+found$[[dir]]', '\.o$[[file]]']
let NERDTreeHijackNetrw=1
let NERDTreeNaturalSort=1
let NERDTreeShowBookmarks=1
let NERDTreeQuitOnOpen=3
let NERDTreeCaseSensitiveSort=0
let NERDTreeStatusline=-1
let NERDTreeWinSize=32
"}}}
"}}}
