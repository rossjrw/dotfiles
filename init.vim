set nocompatible
filetype off
set nu
set cursorline
set scrolloff=8

call plug#begin()
Plug 'vim-scripts/indentpython.vim' " automatic python indentation
Plug 'chriskempson/base16-vim' " theme colours
Plug 'tpope/vim-fugitive' " git integration
Plug 'tpope/vim-commentary' " comment line with gcc,
Plug 'rossjrw/vim-px-to-rem'
Plug 'tpope/vim-surround' " cs to activate
Plug 'gerw/vim-HiLinkTrace'

Plug 'rossjrw/python-syntax'
Plug 'pangloss/vim-javascript'
Plug 'cespare/vim-toml'
Plug 'kchmck/vim-coffee-script'

Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" enable split navigation with Ctrl+direction
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" clear highlights on esc
nnoremap <esc> :noh<CR>:<esc><esc>
" jump to ale errors
nmap <silent> [c <Plug>(ale_previous_wrap)
nmap <silent> ]c <Plug>(ale_next_wrap)

" handle indentation for python
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80

" handle indentation for other stuff
au BufNewFile,BufRead *.js,*.html,*.css,*.json,*.cofee
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80

" highlight whitespace at the end of a line
highlight BadWhiteSpace ctermbg=red guibg=darkred
au BufNewFile,BufRead *.py,*.pyw,*.js,*.html,*.css,*.json,*.coffee,*.md
    \ match BadWhiteSpace /\s\+$/

" enable colour scheme
let g:python_highlight_all=1
let base16colorspace=256
set termguicolors
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif
colorscheme base16-eighties
" function! s:base16_customize() abort
call Base16hi("pythonOperator", g:base16_gui0C, "", g:base16_cterm0C, "", "", "")
call Base16hi("pythonClassVar", "", "", "", "", "italic", "")
call Base16hi("pythonStatement", "", "", "", "", "bold", "")
call Base16hi("pythonRepeat", "", "", "", "", "bold,italic", "")
call Base16hi("pythonFunction", g:base16_gui0D, "", g:base16_cterm0D, "", "bold", "")
" endfunction

" augroup on_change_colorschema
"     autocmd!
"     autocmd ColorScheme * call s:base16_customize()
" augroup END

" set Ctrl-R in VISUAL mode to "replace all instance of this with __"
" Escape special characters in a string for exact matching.
" " This is useful to copying strings from the file to the search tool
" " Based on this -
" http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&
  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')
  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save
  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)
  return escaped_selection
endfunction

" Start the find and replace command across the entire file
vmap <C-r> <Esc>:%s/<c-r>=GetVisual()<cr>/

" config airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_theme = 'powerlineish'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '@'
let g:airline_symbols.maxlinenr = ''
function! AirlineInit()
  call airline#parts#define_raw('linenr', '%l')
  call airline#parts#define_accent('linenr', 'bold')
  call airline#parts#define_raw('percent', '%p')
  call airline#parts#define_accent('percent', 'bold')
  let g:airline_section_x = airline#section#create([])
  let g:airline_section_y = airline#section#create(['percent','%%'])
  let g:airline_section_z = airline#section#create(['linenr', ':%c'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

" config ale
let g:ale_linters['coffeescript'] = 'coffee'
let g:ale_linters['python'] = 'yapf'
