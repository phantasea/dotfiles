" fffm.vim

let g:fffm#split = get(g:, 'fffm#split', '20new')
let g:fffm#split_direction = get(g:, 'fffm#split_direction',
                                  \ 'splitbelow splitright')

function! fffm#open_file(...)
    let tmp_file = $XDG_CACHE_HOME

    if !isdirectory(tmp_file)
        let tmp_file = $HOME . "/.cache"
    endif

    let tmp_file .= "/fffm/opened_file"
    let tmp_file = fnameescape(tmp_file)
    bd!

    if filereadable(tmp_file)
        let file_data = readfile(tmp_file)
        execute delete(tmp_file)
    else
        return
    endif

    if filereadable(file_data[0])
        execute "e " . file_data[0]
    endif
endfunction

function! fffm#Run(command)
    execute 'setlocal' . ' ' . g:fffm#split_direction
    execute g:fffm#split
    execute 'setlocal nonumber'
    execute 'setlocal norelativenumber'

    if has('nvim')
        call termopen('fffm -p ' . a:command,
                    \ {'on_exit': function('fffm#open_file') })
        startinsert
    else
        let buffer = term_start([&shell, &shellcmdflag, 'fffm -p ' . a:command],
                    \ {'curwin': 1, 'exit_cb': function('fffm#open_file')})

        if !has('patch-8.0.1261')
            call term_wait(buffer, 20)
        endif
    endif
endfunction
