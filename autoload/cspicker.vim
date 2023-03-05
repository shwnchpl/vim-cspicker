let s:picking = 0

fu! cspicker#pick(...)
    if s:picking
        echo 'ColorSchemePicker: Already running!'
        return
    endif

    silent 12 new ColorSchemePicker
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile spelllang=
    norm dG

    let s:picking = 1

    let b:cspicker_preview = ''
    if exists('g:colors_name')
        let b:cspicker_orig = g:colors_name
    endif

    aug cspicker
        au!
        au BufWipeout  <buffer> call s:close()
        au CursorMoved <buffer> call s:update()
    aug end
    nnoremap <buffer> <silent> <cr>
        \ :let b:cspicker_selected = b:cspicker_preview<cr>
        \ :bd<cr>

    if a:0 >= 1
        try
            execute('file ColorSchemePicker - ' . a:1)
            execute('read ' . a:1)
        catch /.*/
            bd
            echoerr v:exception
        endtry

        norm ggdd
    else
        put =getcompletion('', 'color')
        norm ggdd

        if exists('g:colors_name')
            try
                execute('/^' . g:colors_name . '$')
            catch /^Vim\%((\a\+)\)\=:E486:/
            catch /.*/
                bd
                echoerr v:exception
            endtry
        endif
    endif

    setlocal ro noma
endfu

fu! s:close()
    if exists('b:cspicker_selected') && b:cspicker_selected != ''
        let l:target = b:cspicker_selected
    elseif exists('b:cspicker_orig')
        let l:target = b:cspicker_orig
    endif

    if exists('l:target')
        execute('colorscheme ' . l:target)
        redraw!
        echo 'ColorSchemePicker: ' . l:target
    endif

    let s:picking = 0
endfu

fu! s:update()
    let l:selected = getline('.')

    if l:selected != b:cspicker_preview
        try
            execute('colorscheme ' . l:selected)
            redraw!
            let b:cspicker_preview = l:selected
            echo 'ColorSchemePicker: ' . b:cspicker_preview . ' (preview)'
        catch /.*/
            let b:cspicker_preview = ''
            echom 'ColorSchemePicker: "' . l:selected . '" not found!'
        endtry
    endif
endfu
