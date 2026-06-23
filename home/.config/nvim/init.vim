set nocompatible
filetype off
set number
set relativenumber
set numberwidth=1
set cursorline
set scrolloff=8

call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'chriskempson/base16-vim' " theme colours
Plug 'tpope/vim-fugitive' " git integration
Plug 'tpope/vim-commentary' " comment line with gcc,

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" enable split navigation with Ctrl+direction
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" traverse display lines, not physical
nnoremap <silent> k gk
nnoremap <silent> j gj
" clear highlights on esc
nnoremap <esc> :noh<CR>:<BS>
" fuck ctrlp, fzf is better
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
nnoremap <C-P> :FZF<CR>

" ^W\ will centre the page
nnoremap <C-W><leader> :vnew<CR>:vertical resize -44<CR><C-W><C-L>:<BS>

" handle indentation for python
au BufNewFile,BufRead *.py,*.md,*.txt
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80

" handle indentation for other stuff
au BufNewFile,BufRead *.js,*.sh,*.yml,*.yaml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80
au BufNewFile,BufRead *.html,*.css,*.json
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80
" highlight whitespace at the end of a line
highlight BadWhiteSpace ctermbg=red guibg=darkred
au BufNewFile,BufRead *.py,*.pyw,*.js,*.html,*.css,*.json,*.md
    \ match BadWhiteSpace /\s\+$/

" enable colour scheme
let base16colorspace=256
set termguicolors
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif
colorscheme base16-eighties
" struggling to get inverted cursor on windows terminal so flashy flashy will
" do
set guicursor=a:blinkon100

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

" Start the find and replace command across the entire file, to find the
" highlighted text when in visual mode
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

" only do highlight stuff for active window
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

" Search for merge conflict markers
command! Conflicts :/^\(<<<<<<<\|=======\|>>>>>>>\)
