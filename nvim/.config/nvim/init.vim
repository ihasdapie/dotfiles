""""""""""""""""""""""""""""""
" => Misc/General
""""""""""""""""""""""""""""""
set number
set autoindent
set smartindent

filetype plugin on
filetype indent on

set nocompatible
set history=500
" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime
set nofoldenable
set foldmethod=syntax
set foldnestmax=1
filetype off
set visualbell
set confirm
" set t_vb=
set mouse=a
set mousemodel=popup_setpos

set noshowmode "to remove redundant --insert-- etc"
set lazyredraw
set nowrap "turn off wrapping"
set title titlestring=%n\:\ %t\ \:\:\ VIM titlelen=70

"set diff=meld; "Use meld for diff as I'm bad with vimdiff"
"
set shortmess=atc
colorscheme deus

" allow for transparent backgrounds
" autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE " transparent bg

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100
set redrawtime=4000

set expandtab
set shiftwidth=4
set colorcolumn=85


"""" for coc.nvim
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Allow for glyphs and indentLine
set conceallevel=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" " Avoid garbled characters in Chinese language windows OS
" let $LANG='en'
" set langmenu=en
" source $VIMRUNTIME/delmenu.vim
" source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

""Always show current position
"set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" set true colors
if (has("termguicolors"))
    set termguicolors
endif


let g:loaded_netrw_Plugin = 1 "NeTrW iS bLoAT

:tnoremap <Esc> <C-\><C-n> " Allow esc to exit out of terminal mode


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows, buffers, splits
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map leader
let mapleader=","

nnoremap k gk
nnoremap j gj

" turn off highlights
map <silent> <leader><cr> :noh<cr>



" buffer movement

" list buffers
nnoremap <leader>bl :buffers<CR>:buffer<Space>

" switching between buffers
map <leader>b :b

" Close the current buffer
map <leader>bd :bd<cr>:tabclose<cr>gT

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" " Specify the behavior when switching between buffers
" try
"     set switchbuf=useopen,usetab,newtab
"     set stal=2
" catch
" endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

nnoremap <silent> <Leader>s :split<CR>
nnoremap <silent> <Leader>v :vsplit<CR>
nnoremap <silent> <Leader>q :close<CR>


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


""""""""""""""
"Binary Files
""""""""""""""
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END




""""""""""""""""""
" Fix cursorhold 
let g:cursorhold_updatetime = 100
"""""""""""""""""



"""""""""""""
" Ale
"""""""""""""
let g:ale_fixers = {
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
    \ }
" let g:ale_linters={
"  \ 'rust' : ['analyzer']
"  \ }


let g:ale_sign_column_always = 1
let g:ale_lint_delay = 1000  " Default, 200ms: I don't need linting that much

let g:ale_disable_lsp = 1
let g:ale_hover_cursor = 1
let g:ale_set_baloons =1 " Show hover tooltip in balloon
""""""""""""""""""
" => Vista.vim
""""""""""""""""""
nmap <silent> <leader>vv :Vista!! <cr>
nmap <silent> <leader>vf :Vista finder <cr>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista#renderer#enable_icon = 1
let g:vista_echo_cursor_strategy = "both" " Floating windows & in prompt bar

let g:vista_default_executive = 'ale'
let g:vista_sidebar_width=40


" For whatever reason coc + vista doesn't work with those arrow eyecandy but it works better
" And I can't get ale to work with the preview popup which i find to be
" useful..
" let g:vista_executive_for = {
    \ 'vim': 'ctags',
    \ 'tex': 'ctags',
    \ 'python': 'coc', 
    \ 'rust': 'coc',
    \ }

" Why is fzf not working?
" fzf#vim#
let g:vista_fzf_preview=['right:50%']
let g:vista_keep_fzf_colors=1
let g:vista_finder_alternative_executives=['coc', 'ctags']
let g:vista_disable_statusline=1
let g:vista#renderer#ctags='kind'
let g:vista_floating_delay=200



" autocmd FileType vista,vista_kind nnoremap <buffer> <silent> \
"              / :<c-u>call vista#finder#fzf#Run()<CR>




"""""
" => FZF
"""""
" set rtp+=/usr/bin/fzf
noremap <c-f> :FZF <CR>

""""""""
" Smooth Scrolling
""""""""
" noremap <silent> <up> :call smooth_scroll#up(&scroll/2, 0, 2)<CR>
" noremap <silent> <down> :call smooth_scroll#down(&scroll/2, 0, 2)<CR>
noremap <silent> <c-k> :call smooth_scroll#up(&scroll/2, 0, 2)<CR>
noremap <silent> <c-j> :call smooth_scroll#down(&scroll/2, 0, 2)<CR>

""""""""""
" => Polyglot
""""""""""
" Polyglot is slow but it is the best option atm will have to use it...

let g:python_highlight_space_errors=0 " Get rid of ugly python red stuff for trailing whitespace


""""""""""""""""""
" ==> SnipRun
""""""""""""""""""

nnoremap <leader>f :SnipRun<CR>
vnoremap <leader>f :SnipRun<CR>

"""""""""""""""""""
" ==> Toggle Transparent Background
"""""""""""""""""""""""""
let t:is_transparent = 1
function! Toggle_transparent()
    if t:is_transparent == 0
        hi Normal ctermbg=black
        execute "colorscheme deus"
        let t:is_transparent = 1
    else
        hi Normal guibg=NONE ctermbg=NONE
        let t:is_transparent = 0
    endif
endfunction


""""""""""""""""""""
" ==> Vim-Matlab
""""""""""""""""""
nmap <leader>mrc :MatlabCliRunCell <cr>

""""""""""""""""
" --> UML
"""""""""""""""
let g:preview_uml_url='http://localhost:8888'

""""""""""""""""""""
" latex
"""""""""""""""""""
let g:tex_flavor = "latex"
let g:vimtex_view_general_viewer = 'zathura'

"""""""""""""""""""""""""""
" --> IndentLine
""""""""""""""""""""""""""""
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_setColors = 0

""""""""""""""""""""""""""""""""
"" => airline
"""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_theme='deus'
let g:airline#extensions#whitespace#enabled=0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline
let g:airline#extensions#tabline#tabs_label = ''       " can put text here like BUFFERS to denote buffers (I clear it so nothing is shown)
let g:airline#extensions#tabline#buffers_label = ''    " can put text here like TABS to denote tabs (I clear it so nothing is shown)
let g:airline#extensions#tabline#show_tab_count = 0    " dont show tab numbers on the right
let g:airline#extensions#tabline#show_splits = 0       " disables the buffer name that displays on the right of the tabline
let g:airline#extensions#tabline#show_tab_nr = 0       " disable tab numbers
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline#extensions#ale#enabled = 1 " show ale stuff in airline


""""""""""""""""""""""""""""""
"" => NerdTree & NerdTreeToggle
"""""""""""""""""""""""""""""""
"map <C-t> :NERDTreeTabsToggle <CR>
"let g:NERDTreeWinPos = "right"
"let NERDTreeShowHidden=0
"let NERDTreeIgnore = ['\.pyc$', '__pycache__']
"let g:NERDTreeWinSize=35

""""""""""""""""""""""""""""""
" => Coc
""""""""""""""""""""""""""""""
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif

" for yanklist
nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>

" for expected behaviour with coc-pairs on hitting enter w/ open ( or {
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.

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
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" rename with coc 
nmap <leader>rn <Plug>(coc-rename)

" Accept Coc Completion on enter
inoremap <silent><expr> <C-enter> pumvisible() ? coc#_select_confirm() : "\ijj>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <leader>cd :CocDiagnostics<cr>
nmap <leader>clc :CocList commands<cr>
nmap <leader>clo :CocList outline<cr>
nmap <leader>cls :CocList symbols<cr>
nmap <leader>cf :CocFix<cr>
""" for coc-actions
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@


""""""""""""""""""""""""
"=>suda.vim
""""""""""""""""""""""""

let g:suda#prefix = 'suda://'
" multiple protocols can be defined too
let g:suda#prefix = ['suda://', 'sudo://', '_://']

""""""""""""
" => TOHtml
""""""""""""
" If this is set to 1, dynamic folds + js is inserted into generated html
let g:html_number_lines = 0 " Omit line numbers in generated html
let g:html_prevent_copy = "fn" " Makes fold markers and numbers in html not copiable

""""""""
" Assorted bindings:
""""""""""


nnoremap <leader>ss :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:noh<CR>            


""""""""""""""""""""""""""""""
" => vim-plug
""""""""""""""""""""""""""""""

" auto-installation script

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.config/nvim/plugged')

" Essentials
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'liuchengxu/vista.vim'
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'


" Performance improvements
Plug 'antoinemadec/FixCursorHold.nvim'

" Eyecandy
Plug 'junegunn/goyo.vim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'terryma/vim-smooth-scroll'
Plug 'ryanoasis/vim-devicons'
" Plug 'preservim/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Tools
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
Plug 'tpope/vim-commentary'
Plug 'lambdalisue/suda.vim'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-surround'

" Other
Plug 'lervag/vimtex'
Plug 'daeyun/vim-matlab'
Plug 'kshenoy/vim-signature'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim' " dependency for plantuml-previewer

call plug#end()

