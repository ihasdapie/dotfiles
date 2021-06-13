"""""""""""""""""""""""""""""
" => Misc/General
""""""""""""""""""""""""""""""
set number
set autoindent
set smartindent

" set guifont=FiraCode\ Nerd\ Font:h30
set guifont=Victor\ Mono\ Bold\ Nerd\ Font\ Complete\ Mono:h30

set rtp+=~/.config/nvim/lua         " Make lua configs 'require' -able

filetype plugin on
filetype indent on

set nocompatible 
set history=500 " Set to auto read when a file is changed from the outside
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
set timeoutlen=690

set title titlestring=VIM\[%t\]\:%n titlelen=70

"set diff=meld; "Use meld for diff as I'm bad with vimdiff
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

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=200
set redrawtime=4000

set expandtab
set shiftwidth=4
" set colorcolumn=80
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

""Always show current position
set ruler

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

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


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
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'
" Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
" Plug 'honza/vim-snippets'
Plug 'ihasdapie/vim-snippets'
Plug 'simnalamburt/vim-mundo'
Plug 'voldikss/vim-floaterm'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}


" Performance improvements
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'tweekmonster/startuptime.vim/'
Plug 'vim-scripts/LargeFile'
Plug 'famiu/nvim-reload'


" Eyecandy
Plug 'kdav5758/TrueZen.nvim'
Plug 'terryma/vim-smooth-scroll'
Plug 'ryanoasis/vim-devicons'
Plug 'mcchrish/nnn.vim'
Plug 'wfxr/minimap.vim'


" Colourschemes
Plug 'gruvbox-community/gruvbox'
Plug 'folke/tokyonight.nvim'
Plug 'ihasdapie/spaceducky'
Plug 'marko-cerovac/material.nvim'
Plug 'sainnhe/sonokai'
Plug 'navarasu/onedark.nvim'
Plug 'dracula/vim'
Plug 'romgrk/doom-one.vim'

" Tools
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
Plug 'b3nj5m1n/kommentary'
Plug 'lambdalisue/suda.vim'
Plug 'nathanaelkane/vim-indent-guides'

" Plug 'Yggdroot/indentLine'
" Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'} " Still waiting on some upstream changes... to fix bug with horz. movement
Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-surround'
Plug 'folke/which-key.nvim'
Plug 'ferrine/md-img-paste.vim'
Plug 'mechatroner/rainbow_csv'


" Plug 'puremourning/vimspector'
Plug 'nvim-lua/plenary.nvim'
Plug 'kevinhwang91/nvim-bqf'

" Other
Plug 'kshenoy/vim-signature' 
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim' "dependency for plantuml-previewer


" Language Syntax
Plug 'lervag/vimtex'
Plug 'daeyun/vim-matlab'
Plug 'liuchengxu/graphviz.vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'axvr/org.vim'


" Experimental
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'




Plug '~/Projects/vim/SCHLAD-list.nvim'


" =>  Graveyard
" Plug 'hoob3rt/lualine.nvim'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'jiangmiao/auto-pairs'

call plug#end()

""""""""""""""""""
" Fix cursorhold 
let g:cursorhold_updatetime = 100
"""""""""""""""""


""""""""""
" => Largefile
"""""""""
let g:LargeFile=50


""""""""""
" => colorscheme
""""""""""

let g:sonokai_enable_italic=1
let g:sonokai_style="atlantis"
let g:sonokai_better_performance=1

let g:tokyonight_italic_functions='true'
let g:tokyonight_colors = {"comment": "#696969"}
let g:tokyonight_sidebars = ["vista", "qf", "vista_kind", "terminal", "packer" ]
let g:tokyonight_style="storm"
let g:tokyonight_dark_float='true'
let g:tokyonight_hide_inactive_statusline='true'
let g:tokyonight_colors = {"comment": "#696969"}

let g:material_italic_functions='true'
let g:material_colors = {"comment": "#696969"}
let g:material_sidebars = ["vista", "qf", "vista_kind", "terminal", "packer" ]
let g:material_style="palenight"
let g:material_dark_float='true'
let g:material_hide_inactive_statusline='true'
let g:material_colors = {"comment": "#696969"}

colorscheme dracula


""""""""""""""""""
" => Vista.vim
""""""""""""""""""
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
    \ 'c' : 'coc',
    \ 'lua': 'coc'
    \ }


let g:vista_fzf_preview=['right:50%']
let g:vista_keep_fzf_colors=1
let g:vista_finder_alternative_executives=['coc', 'ctags']
let g:vista_disable_statusline=1
let g:vista#renderer#ctags='kind'
let g:vista_floating_delay=200




"""""
" => FZF
"""""
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

""""""""
" => Polyglot
""""""""""
" Polyglot is slow but it is the best option atm will have to use it...
let g:python_highlight_space_errors=0 " Get rid of ugly python red stuff for trailing whitespace


"""""""""""""""""""
" ==> Toggle Transparent Background
"""""""""""""""""""""""""
let t:is_transparent = 1
function! Toggle_transparent()
    if t:is_transparent == 0
        hi Normal ctermbg=black
        set background=dark
        execute "colorscheme tokyonight"

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



""""""""""""
" => Galaxyline
""""""""""""
lua require('galaxyline_config')



""""""""""""""""""
" ==> lualine
""""""""""""""""""""
" lua require('lualine_config')



""""""""""""""""
" ==> nvim-bufferline
""""""""""""""""
lua require('nvim-bufferline_config')


""""""""""""""""""""""""""""""
" => Coc
""""""""""""""""""""""""""""""


" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')




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


"""""""""""""
"=> nnn.vim
"""""""""""""
let g:nnn#set_default_mappings=0
let g:nnn#layout = { 'window': { 'width': 0.5, 'height': 0.7} }
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


""""""""""""""""""
" ==> nvim-which-key
""""""""""""""""""
lua require('which-key_config')


""""""""
"=> Hide quickfix 
"""""
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END


""""""""""
" => md-image-paste
""""""""""
let g:mdip_imgdir = 'img'
let g:mdip_imgname = 'image'


"""""""""""
" => Peartree
"""""""""""
let g:pear_tree_repeatable_expand=0 " get expected behaviour when autoinserting closures
let g:pear_tree_smart_openers=1
let g:pear_tree_smart_closers=1
let g:pear_tree_smart_backspace=1




"""""""""""""""""
" => Nvim Lua Dev  
"""""""""""""""'
let g:vimsyn_embed = 'l'


"""""""""""""""""""""""""""
" --> IndentGuide
""""""""""""""""""""""""""""
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_default_mapping=0
let g:indent_guides_exclude_filetypes = ['help', 'qf', 'quickfix', 'whichkey', 'WhichKey', 'nofile']


"""""""""""""""
" => Keybinds
"""""""""""
silent source ~/.config/nvim/keybindings.vim
" The rest of the keybindings can be found in ./lua/which-key_config.lua

"""""""""
" => Scratch Buffer
"""""""""""""""
function! Scratch()
    vsplit
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    "setlocal nobuflisted
    "lcd ~
    file scratch
endfunction



""""""""""""""""""""""
" => Rainbow csv
""""""""""""""'
let g:disable_rainbow_key_mappings = 1










