if exists('s:loaded')
    finish
endif
let s:loaded = 1

command! -bar -nargs=? -complete=file ColorSchemePicker
    \ call cspicker#pick(<f-args>)
