""""""""""""""""""""""""""""""
" => Misc/General
""""""""""""""""""""""""""""""
set number
set autoindent
set smartindent

set guifont=FiraCode\ Nerd\ Font:h30


set rtp+=~/.config/nvim/lua         " Make lua configs 'require' -able

filetype plugin on
filetype indent on

set nocompatible
set history=500
" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime
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


  " guard for distributions lacking the 'persistent_undo' feature.
if has('persistent_undo')
    " define a path to store persistent undo files.
    let target_path = expand('~/.config/nvim/undo/')    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif    " point Vim to the defined undo directory.
    let &undodir = target_path    " finally, enable undo persistence.
    set undofile
endif 

" allow for transparent backgrounds
" autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE " transparent bg

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100
set redrawtime=4000

set expandtab
set shiftwidth=4
set colorcolumn=80
set signcolumn=auto


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
let g:loaded_netrw=1

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

map <leader>cb :set clipboard+=unnamedplus<cr>
map <leader>cf :copen <cr>


" buffer movement

" list buffers
""""""
" Overrideen via barbar
""""""
" " switching between buffers
" map <leader>b :b

" " Close the current buffer
" map <leader>bd :bd<cr>:tabclose<cr>gT

" map <leader>l :bnext<cr>
" map <leader>h :bprevious<cr>

" " Useful mappings for managing tabs
" map <leader>tn :tabnew<cr>
" map <leader>to :tabonly<cr>
" map <leader>tc :tabclose<cr>
" map <leader>tm :tabmove
" map <leader>t<leader> :tabnext

" " Opens a new tab with the current buffer's path
" " Super useful when editing files in the same directory
" map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer

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
augroup binary
  au!
  au bufreadpre  *.bin let &bin=1
  au bufreadpost *.bin if &bin | %!xxd
  au bufreadpost *.bin set ft=xxd | endif
  au bufwritepre *.bin if &bin | %!xxd -r
  au bufwritepre *.bin endif
  au bufwritepost *.bin if &bin | %!xxd
  au bufwritepost *.bin set nomod | endif
augroup end

augroup elf_files
  au!
  au BufReadPre  *.elf let &bin=1
  au BufReadPost *.elf if &bin | %!xxd
  au BufReadPost *.elf set ft=xxd | endif
  au BufWritePre *.elf if &bin | %!xxd -r
  au BufWritePre *.elf endif
  au BufWritePost *.elf if &bin | %!xxd
  au BufWritePost *.elf set nomod | endif
augroup END

augroup object_files
  au!
  au BufReadPre  *.o let &bin=1
  au BufReadPost *.o if &bin | %!xxd
  au BufReadPost *.o set ft=xxd | endif
  au BufWritePre *.o if &bin | %!xxd -r
  au BufWritePre *.o endif
  au BufWritePost *.o if &bin | %!xxd
  au BufWritePost *.o set nomod | endif
augroup END


"""""""
"=> assembly
"""""""
" Detect asm filetypes
augroup NASM
    au BufNewFile *.nasm setfiletype nasm
    au BufRead *.nasm setfiletype nasm
augroup END

augroup ASM
    au BufNewfile *.asm setfiletype asm
    au BufRead *.asm setfiletype asm
augroup END

let g:asmsyntax='nasm'

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
let g:ale_linters={
            \ 'rust' : ['analyzer'],
            \ 'python' : ['pyright']
            \ }


let g:ale_sign_column_always = 1
let g:ale_lint_delay = 1000  " Default, 200ms: I don't need linting that much

let g:ale_disable_lsp = 1
let g:ale_hover_cursor = 1
let g:ale_set_balloons =1 " Show hover tooltip in balloon


"""""""""""""""""""""""""""""
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
Plug 'lewis6991/gitsigns.nvim'
" Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Plug 'airblade/vim-gitgutter'

" Performance improvements
Plug 'antoinemadec/FixCursorHold.nvim'

" Eyecandy
" Plug 'junegunn/goyo.vim'
Plug 'kdav5758/TrueZen.nvim'
Plug 'flazz/vim-colorschemes/'
Plug 'terryma/vim-smooth-scroll'
Plug 'ryanoasis/vim-devicons'
Plug 'mcchrish/nnn.vim'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'ihasdapie/spaceducky'
Plug 'ihasdapie/airline_base16_snazzy'
Plug 'romgrk/doom-one.vim'
Plug 'joshdick/onedark.vim'

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'

" Tools
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
Plug 'b3nj5m1n/kommentary'
Plug 'lambdalisue/suda.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-surround'
" Plug 'liuchengxu/vim-which-key' #
" https://github.com/liuchengxu/vim-which-key TODO: put together bindings dict
" Plug 'puremourning/vimspector'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'liuchengxu/graphviz.vim'
Plug 'nvim-lua/plenary.nvim'

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'



" Other
Plug 'lervag/vimtex'
Plug 'daeyun/vim-matlab'
Plug 'kshenoy/vim-signature'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim' " dependency for plantuml-previewer


" Experimental
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'

call plug#end()

colorscheme spaceducky
""""""""""""""""""
" => Vista.vim
""""""""""""""""""
nmap <silent> <leader>vv :Vista!! <cr>
nmap <silent> <leader>vf :Vista finder <cr>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista#renderer#enable_icon = 1
let g:vista_echo_cursor_strategy = "both" " Floating windows & in prompt bar

let g:vista_default_executive = 'ctags'
let g:vista_sidebar_width=35


" For whatever reason coc + vista doesn't work with those arrow eyecandy but it works better
" And I can't get ale to work with the preview popup which i find to be


" ctags for c has function prototypes, coc seems a little better tho
let g:vista_executive_for = {
    \ 'python': 'coc', 
    \ 'rust': 'coc',
    \ 'c' : 'coc' 
    \ }


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
noremap <c-f> :Files <CR>
noremap <leader>wl :Windows  <CR>
nnoremap <leader>bl :Buffers <CR>
nnoremap <leader>rg :Rg <CR>
nnoremap <leader>ml :Marks <CR>



let g:fzf_preview_window = ['right:50%', 'ctrl-/']



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
        set background=dark
        execute "colorscheme spaceducky"
        let t:is_transparent = 1
        echo "Transparency off"
    else
        hi Normal guibg=NONE ctermbg=NONE
        let t:is_transparent = 0
        echo "Transparency on"
    endif
endfunction



"""""""""""""""
" => Prose Mode
"""""""""""""""
function! Prose_mode()
    execute ":TZLeft"
    execute ":TZBottom"
    execute ":set linebreak"
    execute ":set wrap"


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
" vimtex
""""""""""""""""""""
let g:tex_flavor = "latex"
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'

" let g:vimtex_compiler_progname = 'nvr'

"""""""""""""""""""""""""""
" --> IndentGuide
""""""""""""""""""""""""""""
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_default_mapping=0


""""""""""""""""""""""""""""""""
"" => airline
"""""""""""""""""""""""""""""""
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline_theme='old_base16_snazzy'

" let g:airline#extensions#whitespace#enabled=0
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline
" let g:airline#extensions#tabline#tabs_label = ''       " can put text here like BUFFERS to denote buffers (I clear it so nothing is shown)
" let g:airline#extensions#tabline#buffers_label = ''    " can put text here like TABS to denote tabs (I clear it so nothing is shown)
" let g:airline#extensions#tabline#show_tab_count = 0    " dont show tab numbers on the right
" let g:airline#extensions#tabline#show_splits = 0       " disables the buffer name that displays on the right of the tabline
" let g:airline#extensions#tabline#show_tab_nr = 0       " disable tab numbers
" let g:airline#extensions#tabline#buffer_nr_show = 1

" let g:airline#extensions#ale#enabled = 1 " show ale stuff in airline

" let g:airline#extensions#bufferline#enabled = 1

" let g:airline_left_sep=''
" let g:airline_right_sep = ''
" let g:airline_left_alt_sep=''
" let g:airline_right_alt_sep=''

""""""""""""""""""
" ==> lualine
""""""""""""""""""""

let g:lualine = {
    \'options' : {
    \  'theme' : 'palenight',
    \  'section_separators' : ['', ''],
    \  'component_separators' : ['', ''],
    \  'icons_enabled' : v:true,
    \},
    \'sections' : {
    \  'lualine_a' : [ ['mode', {'upper': v:true,},], ],
    \  'lualine_b' : [ ['branch', {'icon': '',}, ], ],
    \  'lualine_c' : [ ['filename', {'file_status': v:true,},], ],
    \  'lualine_x' : [ 'encoding', 'fileformat', 'filetype' ],
    \  'lualine_y' : [ 'progress' ],
    \  'lualine_z' : [ 'location'  ],
    \},
    \'inactive_sections' : {
    \  'lualine_a' : [  ],
    \  'lualine_b' : [  ],
    \  'lualine_c' : [ 'filename' ],
    \  'lualine_x' : [ 'location' ],
    \  'lualine_y' : [  ],
    \  'lualine_z' : [  ],
    \},
    \'extensions' : [ 'fzf', 'fugitive',  ],
    \}

lua require("lualine").setup()

""""""""""""""""
" ==> Barbar
""""""""""""""""

" NOTE: If barbar's option dict isn't created yet, create it
let bufferline = get(g:, 'bufferline', {})

" Enable/disable animations
let bufferline.animation = v:false

" Enable/disable auto-hiding the tab bar when there is a single buffer
let bufferline.auto_hide = v:true

" Enable/disable current/total tabpages indicator (top right corner)
let bufferline.tabpages = v:true

" Enable/disable close button
let bufferline.closable = v:true

" Enables/disable clickable tabs
"  - left-click: go to buffer
"  - middle-click: delete buffer
let bufferline.clickable = v:true

" Enable/disable icons
" if set to 'numbers', will show buffer index in the tabline
" if set to 'both', will show buffer index and icons in the tabline
let bufferline.icons = v:true

" Sets the icon's highlight group.
" If false, will use nvim-web-devicons colors
let bufferline.icon_custom_colors = v:false

" Configure icons on the bufferline.
let bufferline.icon_separator_active = '▎'
let bufferline.icon_separator_inactive = '▎'
let bufferline.icon_close_tab = ''
let bufferline.icon_close_tab_modified = '●'

" Sets the maximum padding width with which to surround each tab
let bufferline.maximum_padding = 2

" If set, the letters for each buffer in buffer-pick mode will be
" assigned based on their name. Otherwise or in case all letters are
" already assigned, the behavior is to assign letters in order of
" usability (see order below)
let bufferline.semantic_letters = v:true

" New buffer letters are assigned in this order. This order is
" optimal for the qwerty keyboard layout but might need adjustement
" for other layouts.
let bufferline.letters =
  \ 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP'

" Sets the name of unnamed buffers. By default format is "[Buffer X]"
" where X is the buffer number. But only a static string is accepted here.
let bufferline.no_name_title = v:null

map <leader>bd :BufferClose<cr>
map <leader>bp :BufferPick<cr>

map <leader>l :BufferNext<cr>
map <leader>h :BufferPrevious<cr>

" map gt :BufferNext<cr>
" map gT :BufferPrevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/




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

nnoremap <leader>ce :CocCommand explorer <cr>
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

" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" rename with coc 
nmap <leader>rn <Plug>(coc-rename)

" Accept Coc Completion on enter
inoremap <silent><expr> <C-enter> pumvisible() ? coc#_select_confirm() : "\ijj>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <leader>cdi :CocList diagnostics<cr>
nmap <leader>clc :CocList commands<cr>
nmap <leader>clo :CocList outline<cr>
nmap <leader>cls :CocList symbols<cr>
nmap <leader>cfi :CocFix<cr>

""" for coc-actions
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@



" Coc go to definition
nmap <silent> gd :call CocAction('jumpDefinition', 'tabe')<CR>






"""""""""""""""""""""""
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

"""""""""""""
"=> nnn.vim
"""""""""""""
let g:nnn#set_default_mappings=0
nnoremap <silent> <c-t> :NnnPicker %:p:h<cr>
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6} }
let g:nnn#repalce_netrw=1 " replace netrw when opening directory
let g:nnn#command = 'NNN_COLORS="2136" NNN_TRASH=1 nnn -d'
let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit' }
"""""""""""""
" => Treesitter
"""""""""""""
lua require('treesitter_config')
set nofoldenable
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldnestmax=2


""""""""""
" => Gitsigns.nvim
"""""""""
lua require('gitsigns_config')






""""""""
"=> Hide quickfix 
"""""
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

""""""""""
" => Gitgutter
""""""""""""
