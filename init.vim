set nocompatible
filetype off
set number
set relativenumber
set numberwidth=1
set cursorline
set scrolloff=8

" disable language servers so that coc can have them instead
let g:ale_disable_lsp = 1

call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rossjrw/indentpython.vim' " automatic python indentation
Plug 'chriskempson/base16-vim' " theme colours
Plug 'tpope/vim-fugitive' " git integration
Plug 'tpope/vim-commentary' " comment line with gcc,
Plug 'rossjrw/vim-px-to-rem'
Plug 'tpope/vim-surround' " cs to activate
Plug 'gerw/vim-HiLinkTrace'
Plug 'editorconfig/editorconfig-vim'

Plug 'rossjrw/python-syntax'
Plug 'pangloss/vim-javascript'
Plug 'cespare/vim-toml'
Plug 'rossjrw/vim-coffee-script'
Plug 'posva/vim-vue'
Plug '2072/PHP-Indenting-for-VIm'
Plug 'StanAngeloff/php.vim'
Plug 'jasonshell/vim-svg-indent'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'cakebaker/scss-syntax.vim'

Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'wakatime/vim-wakatime'
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
" jump to ale errors
nmap <silent> [c <Plug>(ale_previous_wrap)
nmap <silent> ]c <Plug>(ale_next_wrap)
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
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80

" handle indentation for other stuff
au BufNewFile,BufRead *.js,*.coffee,*.ts,*.sh,*.vue,*.toml,*.yml,*.yaml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80
au BufNewFile,BufRead *.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80
au BufNewFile,BufRead *.php,*.json
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80
let g:PHP_vintage_case_default_indent = 1

" highlight whitespace at the end of a line
highlight BadWhiteSpace ctermbg=red guibg=darkred
au BufNewFile,BufRead *.py,*.pyw,*.js,*.html,*.css,*.json,*.coffee,*.md,*.ts
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
" for rossjrw/python-syntax
call Base16hi("pythonOperator", g:base16_gui0C, "", g:base16_cterm0C, "", "", "")
call Base16hi("pythonClassVar", "", "", "", "", "italic", "")
call Base16hi("pythonStatement", "", "", "", "", "bold", "")
call Base16hi("pythonRepeat", "", "", "", "", "bold,italic", "")
call Base16hi("pythonFunction", g:base16_gui0D, "", g:base16_cterm0D, "", "bold", "")
" for pangloss/vim-javascript
call Base16hi("jsThis", g:base16_gui05, "", g:base16_cterm05, "", "italic", "")
call Base16hi("jsFunction", "", "", "", "", "bold", "")
call Base16hi("jsFuncName", "", "", "", "", "bold", "")
call Base16hi("jsStorageClass", g:base16_gui0F, "", g:base16_cterm0F, "", "", "")
call Base16hi("jsOperatorKeyword", g:base16_gui0E, "", g:base16_cterm0E, "", "", "")
call Base16hi("jsGlobalObjects", g:base16_gui0D, "", g:base16_cterm0D, "", "", "")
call Base16hi("jsNull", g:base16_gui09, "", g:base16_cterm09, "", "", "")
call Base16hi("jsUndefined", g:base16_gui09, "", g:base16_cterm09, "", "", "")
call Base16hi("jsRepeat", g:base16_gui0E, "", g:base16_cterm0E, "", "bold,italic", "")
call Base16hi("jsExceptions", g:base16_gui08, "", g:base16_cterm08, "", "", "")
call Base16hi("jsOperator", g:base16_gui0C, "", g:base16_cterm0C, "", "", "")
call Base16hi("jsBuiltins", g:base16_gui0D, "", g:base16_cterm0D, "", "", "")
" for rossjrw/vim-coffee-script
call Base16hi("coffeeOperator", g:base16_gui0C, "", g:base16_cterm0C, "", "", "")
call Base16hi("coffeeConditional", g:base16_gui0E, "", g:base16_cterm0E, "", "", "")
call Base16hi("coffeeStatement", g:base16_gui0E, "", g:base16_cterm0E, "", "bold", "")
call Base16hi("coffeeDotAccess", g:base16_gui04, "", g:base16_cterm04, "", "", "")
call Base16hi("coffeeBracket", g:base16_gui04, "", g:base16_cterm04, "", "", "")
call Base16hi("coffeeParen", g:base16_gui04, "", g:base16_cterm04, "", "", "")
call Base16hi("coffeeCurly", g:base16_gui04, "", g:base16_cterm04, "", "", "")
call Base16hi("coffeeSpecialVar", g:base16_gui0D, "", g:base16_cterm0D, "", "", "")
call Base16hi("coffeeGlobal", g:base16_gui09, "", g:base16_cterm09, "", "", "")
call Base16hi("coffeeRepeat", g:base16_gui0E, "", g:base16_cterm0E, "", "bold,italic", "")
call Base16hi("coffeeObjAssign", g:base16_gui0A, "", g:base16_cterm0A, "", "", "")
call Base16hi("coffeeSpecialIdent", g:base16_gui05, "", g:base16_cterm05, "", "italic", "")
call Base16hi("coffeeThis", g:base16_gui05, "", g:base16_cterm05, "", "italic", "")
call Base16hi("coffeeSymbol", g:base16_gui0A, "", g:base16_cterm0A, "", "", "")
call Base16hi("coffeeFunction", g:base16_gui0D, "", g:base16_cterm0D, "", "bold", "")
" for darkholme ts
call Base16hi("typescriptBinaryOp", g:base16_gui0C, "", g:base16_cterm0C, "", "", "")
call Base16hi("typescriptAssign", g:base16_gui0E, "", g:base16_cterm0E, "", "", "")
call Base16hi("typescriptObjectSpread", g:base16_gui0C, "", g:base16_cterm0C, "", "", "")
" endfunction
" struggling to get inverted cursor on windows terminal so flashy flashy will
" do
set guicursor=a:blinkon100

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
let g:ale_linters = {
\   'javascript': ['standardx', 'eslint'],
\   'typescript': ['standardx', 'eslint'],
\   'coffeescript': ['coffee'],
\   'python': ['pylint'],
\   'sh': ['shellcheck'],
\}
" let g:ale_python_pylint_options = '--init-hook=''import sys; sys.path.append(".")'''
let g:ale_virtualenv_dir_names = ['.venv']
let g:ale_python_auto_pipenv = 1
let g:ale_python_pylint_auto_pipenv = 1

" only do highlight stuff for active window
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

" ##### Standard coc config #####

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <space>o  :<C-u>CocList outline<cr>
" Search orkspace symbols
nnoremap <space>s  :<C-u>CocList -I symbols<cr>
" Jump to next error
nnoremap <space>j  <Plug>(coc-diagnostic-next)
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Search for merge conflict markers
command! Conflicts :/^\(<<<<<<<\|=======\|>>>>>>>\)

" Don't render html (??) (posva/vim-vue#135)
let html_no_rendering=1
