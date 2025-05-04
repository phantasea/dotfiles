" Author: Chris Yang @ Dec 12th, 2014

if exists("g:loaded_linemark") 
   finish
endif
let g:loaded_linemark = 1

nnoremap  <silent> ml :call <SID>HighlightLine() \| nohls<CR>
nnoremap  <silent> mL :call <SID>HighlightClear()<CR>

let g:hili_bg = ["Blue",  "Cyan",  "Green", "Magenta", "Red",   "Yellow", "White"]
let g:hili_fg = ["Black", "Black", "Black", "Black",   "Black", "Black",  "Black"]
let g:hili_idx = 0
let g:hili_grp = ["","","","","","",""]

func! <SID>HighlightLine()
    let bnum = bufnr('%')
    let lnum = line(".")
    let grp = 'HILI_'. bnum. '_'. lnum

    let idx = index(g:hili_grp, grp)
    if idx >= 0
        exec 'syn clear '.grp
        let g:hili_grp[idx] = ""

        let ch = strpart(g:hili_bg[idx], 0, 1)
        exec "delmarks ".ch

        let g:hili_idx = idx
        return
    endif

    let bg  = g:hili_bg[g:hili_idx]
    let fg  = g:hili_fg[g:hili_idx]
    let pat = '/\%'. lnum. 'l.*/'

    exec 'hi '.grp.' ctermfg='.fg.' ctermbg='.bg
    exec 'syn match '.grp.' '.pat.' containedin=ALL'

    let ch = strpart(bg, 0, 1)
    exec "normal m".ch

    if g:hili_grp[g:hili_idx] != ""
        let lst = split(g:hili_grp[g:hili_idx], '_')
        let bno = str2nr(lst[1])
        if bno != bnum
            exec 'b '.bno
            exec 'syn clear '.g:hili_grp[g:hili_idx]
            b #
        else
            exec 'syn clear '.g:hili_grp[g:hili_idx]
        endif
    endif

    let g:hili_grp[g:hili_idx] = grp

    for idx in range(len(g:hili_grp))
        if g:hili_grp[idx] == ""
            let g:hili_idx = idx
            return
        endif
    endfor

    let g:hili_idx += 1
    let g:hili_idx = g:hili_idx % 7
endfunc

func! <SID>HighlightClear()
    let bnum = bufnr('%')
    for idx in range(len(g:hili_grp))
        if g:hili_grp[idx] == ""
            continue
        endif

        let lst = split(g:hili_grp[idx], '_')
        let bno = str2nr(lst[1])
        if bno != bnum
            exec 'b '.bno
            exec 'syn clear '. g:hili_grp[idx]
            b #
        else
            exec 'syn clear '. g:hili_grp[idx]
        endif

        let g:hili_grp[idx] = ""

        let ch = strpart(g:hili_bg[idx], 0, 1)
        exec 'delmarks '.ch
    endfor

    let g:hili_idx = 0
endfunc
