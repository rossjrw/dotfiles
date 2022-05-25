set nocompatible
filetype off

" set runtime path to include Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let vundle manage vundle
Plugin 'gmarik/Vundle.vim'

" add other plugins here:

Plugin 'tmhedberg/SimpylFold' " enables block folding
Plugin 'vim-scripts/indentpython.vim' " automatic python indentation
Plugin 'Valloric/YouCompleteMe' " autocomplete
Plugin 'chriskempson/base16-vim' " theme colours
Plugin 'kien/ctrlp.vim' " enable Ctrl+P big search boi
Plugin 'tpope/vim-fugitive' " git integration
Plugin 'tpope/vim-commentary' " comment line with gcc,
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'} " powerline
Plugin 'cespare/vim-toml' " toml syntax highlighting
Plugin 'rossjrw/vim-px-to-rem'
Plugin 'tpope/vim-surround' " cs to activate
Plugin 'vim-syntastic/syntastic'
Plugin 'rossjrw/python-syntax'
Plugin 'scrooloose/NERDTree'

" ...

call vundle#end()
filetype plugin indent on

" enable split navigation with Ctrl+direction
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" use bd to close the current buffer
cnoremap bd bp<bar>sp<bar>bn<bar>bd<CR>

" enable folding
set foldmethod=indent
set foldlevel=99

" enable folding with space instead of za
nnoremap <space> za

" map a thingy to refresh the ctrlp cache
map <leader>p :CtrlPClearCache<cr>

" make ctrlp ignore git and env
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|env'

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
au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

" highlight whitespace at the end of a line
highlight BadWhiteSpace ctermbg=red guibg=darkred
au BufNewFile,BufRead *.py,*.pyw,*.js,*.html,*.css
    \ match BadWhiteSpace /\s\+$/

" set encoding
set encoding=utf-8

" some stuff to configure YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" something about virtualenv???
" py << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
" 	project_base_dir = os.environ['VIRTUAL_ENV']
" 	activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
" 	execfile(activate_this, dict(__file__=activate_this))
" EOF

" syntax highlighting
" let python_highlight_all=1
" syntax on
" let g:syntastic_python_checkers = ['python3']

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

" enable line numbers
set nu

" enable cursorline
set cursorline

" automatically open a tree
"autocmd vimenter * NERDTree
"let NERDTreeIgnore = ['NothingShouldMatchThis']

" use system clipboard
set clipboard=unnamed

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2

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

" Add a vertical buffer
set scrolloff=8

" Honeslty not sure what this does`
filetype plugin indent on
