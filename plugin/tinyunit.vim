if exists('g:loaded_tinyunit') | finish | endif
let g:loaded_tinyunit = 1
lua require('tinyunit').setup()
