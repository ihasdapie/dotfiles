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
set updatetime=300
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
set cmdheight=2

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

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


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

" Code stuff 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

" Plug 'itchyny/lightline.vim'
" Plug 'mengelbrecht/lightline-bufferline' " Lightline bufferline does not
" behave the way I want it to

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


Plug 'rafi/awesome-vim-colorschemes'
Plug 'tpope/vim-commentary'
Plug 'lambdalisue/suda.vim'
Plug 'Yggdroot/indentLine'
Plug 'lervag/vimtex'
Plug 'junegunn/fzf'
Plug 'daeyun/vim-matlab'
Plug 'kshenoy/vim-signature'

" UML
"Plug 'skanehira/preview-uml.vim'
" Plug 'scrooloose/vim-slumlord'

Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim' " dependency for plantuml-previewer


Plug 'skywind3000/vim-quickui'
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'liuchengxu/vista.vim'
Plug 'dense-analysis/ale'
" Utility

" Prettyify
Plug 'ryanoasis/vim-devicons'
Plug 'terryma/vim-smooth-scroll'
Plug 'sheerun/vim-polyglot'
call plug#end()


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
" => Vista.vim
""""""""""""""""""
nmap <silent> <c-v> :Vista!! <cr>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista#renderer#enable_icon = 1
let g:vista_echo_cursor_strategy = "both" " Floating windows & in prompt bar

let g:vista_default_executive = 'ale' 

"let g:vista_executive_for = {
"  \ 'cpp': 'vim_lsp',
"  \ 'php': 'vim_lsp',
"  \ }



"""""
" => FZF
"""""
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




" let g:context_menu_k = [
"         \ ["&Help Keyword\t\\ch", 'echo 100' ],
"         \ ["&Signature\t\\cs", 'echo 101'],
"         \ ['-'],
"         \ ["Find in &File\t\\cx", 'echo 200' ],
"         \ ["Find in &Project\t\\cp", 'echo 300' ],
"         \ ["Find in &Defintion\t\\cd", 'echo 400' ],
"         \ ["Search &References\t\\cr", 'echo 500'],
"         \ ['-'],
"         \ ["&Documentation\t\\cm", 'echo 600'],
"         \ ]

" nnoremap <leader>k :call quickui#tools#clever_context('k', g:context_menu_k, {})<cr>





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
" let g:airline_section_b = '%{getcwd()}' " in section B of the status line display the CWD                                                 

let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline                                            
let g:airline#extensions#tabline#tabs_label = ''       " can put text here like BUFFERS to denote buffers (I clear it so nothing is shown)
let g:airline#extensions#tabline#buffers_label = ''    " can put text here like TABS to denote tabs (I clear it so nothing is shown)      
let g:airline#extensions#tabline#show_tab_count = 0    " dont show tab numbers on the right                                                           
let g:airline#extensions#tabline#show_splits = 0       " disables the buffer name that displays on the right of the tabline               
let g:airline#extensions#tabline#show_tab_nr = 0       " disable tab numbers                                                              
let g:airline#extensions#tabline#buffer_nr_show = 1
"""""""""""""""""""""""""""""
" => Lightline 
"""""""""""""""""""""""""""""""

" let g:lightline = {
"             \ 'colorscheme': 'deus',
"             \ 'active': {
"             \   'left': [ [ 'mode', 'paste' ],
"             \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
"             \ },
"             \ 'tabline' : {
"             \ 'left': [ [ 'buffers'] ],
"             \ 'right': [ ['close'] ]
"             \ },
"             \ 'component_expand': {
"             \   'buffers': 'lightline#bufferline#buffers'
"             \ },
"             \ 'component_type': {
"             \   'buffers': 'tabsel'
"             \ },
"             \ 'component_function': {
"             \   'gitbranch': 'FugitiveHead'
"             \ },
"             \ }
" let g:lightline#bufferline#show_number=1 " Add buffer # as shown by :ls to bufferline
" let g:lightline#bufferline#unicode_symbols=1 " prettier bufferline symbols 
" let g:lightline#bufferline#clickable=1 " make clickable
" let g:lightline.component_raw = {'buffers': 1}

""""""""""""""""""""""""""""""
" => NerdTree & NerdTreeToggle
""""""""""""""""""""""""""""""
map <C-t> :NERDTreeTabsToggle <CR>
map <M-t> :NERDTree <Br
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35


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
""""suda.vim
""""""""""""""""""""""""

let g:suda#prefix = 'suda://'
" multiple protocols can be defined too
let g:suda#prefix = ['suda://', 'sudo://', '_://']









