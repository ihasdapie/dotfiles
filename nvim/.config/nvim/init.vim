"""""""""""""""""""""""""""""
" => Misc/General
""""""""""""""""""""""""""""""
set number
set autoindent
set smartindent
set cursorline

set guifont=FiraCode\ Nerd\ Font:h30
" set guifont=Victor\ Mono\ Bold\ Nerd\ Font\ Complete\ Mono:h30

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
set timeoutlen=420

set title titlestring=VIM\[%t\]\:%n titlelen=70


" Set python interpreters; this speeds up startup time but not necessary
let g:python3_host_prog="/usr/bin/python3"
let g:python_host_prog="/usr/bin/python2"




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
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif

call plug#begin('~/.config/nvim/plugged')

" Essentials
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim', {'on': ['Vista']}
Plug 'benwainwright/fzf-project', {'on': ['FzfSwitchProject', 'FzfChooseProjectFile']}
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'ihasdapie/vim-snippets'
Plug 'voldikss/vim-floaterm', {'on': ['FloatermFirst', 'FloatermHide', 'FloatermKill', 'FloatermLast', 'FloatermNew', 'FloatermNext', 'FloatermPrev', 'FloatermSend', 'FloatermShow', 'FloatermToggle', 'FloatermUpdate', 'FloatermFirst']}
" Plug 'akinsho/nvim-bufferline.lua'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kshenoy/vim-signature' 
Plug 'famiu/bufdelete.nvim', {'on': ['Bdelete', 'BWipeout']}
Plug 'mbbill/undotree', {'on': ['UndotreeToggle']}

" Plug 'dense-analysis/ale'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'


" Performance improvements
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'tweekmonster/startuptime.vim/', {'on': 'StartupTime'}
Plug 'vim-scripts/LargeFile'
Plug 'famiu/nvim-reload'


" Eyecandy
Plug 'kdav5758/TrueZen.nvim', {'on': ['TZMinimalist', 'TZAtaraxis']}
Plug 'terryma/vim-smooth-scroll'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'mcchrish/nnn.vim', {'on': 'NnnPicker'}
Plug 'wfxr/minimap.vim', {'on': ['MinimapToggle']}
Plug 'glepnir/dashboard-nvim'



" Colourschemes
Plug 'gruvbox-community/gruvbox',  {'on': ['Colors']}
Plug 'folke/tokyonight.nvim',  {'on': ['Colors']}
Plug 'ihasdapie/spaceducky',  {'on': ['Colors']}
Plug 'marko-cerovac/material.nvim',  {'on': ['Colors']}
Plug 'sainnhe/sonokai',  {'on': ['Colors']}
Plug 'navarasu/onedark.nvim', {'on': ['Colors']}
Plug 'romgrk/doom-one.vim', {'on': ['Colors']}
Plug 'dracula/vim'



" Tools
Plug 'michaelb/sniprun', {'do': 'bash install.sh', 'on': ['SnipRun', ]}
Plug 'b3nj5m1n/kommentary'
Plug 'lambdalisue/suda.vim', {'on': ['SudaRead', 'SudaWrite']}
Plug 'nathanaelkane/vim-indent-guides'
" Plug 'Yggdroot/indentLine'
" Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'} " Still waiting on some upstream changes... to fix bug with horz. movement
Plug 'rafi/vim-venom', { 'for': 'python' }

Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-surround'
Plug 'folke/which-key.nvim'
Plug 'ferrine/md-img-paste.vim'
Plug 'mechatroner/rainbow_csv', {'for': ['csv']}


" Plug 'puremourning/vimspector'
Plug 'nvim-lua/plenary.nvim'
Plug 'kevinhwang91/nvim-bqf'

" Other
Plug 'weirongxu/plantuml-previewer.vim', {'for': 'plantuml'}
Plug 'tyru/open-browser.vim', {'on': ['OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch']} "dependency for plantuml-previewer

" Language Syntax
Plug 'lervag/vimtex', {'for': ['tex', 'bib']}
Plug 'daeyun/vim-matlab', {'for': ['matlab', 'octave']}
Plug 'liuchengxu/graphviz.vim', {'for': ['dot'] }
Plug 'vim-pandoc/vim-pandoc', {'for': ['pandoc']}
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': ['pandoc']}
Plug 'axvr/org.vim', {'for': ['org']}


" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground', {'on': ['TSPlaygroundToggle']}
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'p00f/nvim-ts-rainbow'


" Experimental

" Plug 'nvim-telescope/telescope.nvim'
" Plug 'nvim-lua/popup.nvim'

Plug 'mg979/vim-visual-multi'
Plug '~/Projects/vim/SCHLAD-list.nvim', {'for': ['markdown', 'txt', 'org']}
Plug '~/Projects/vim/nvim-bufferline.lua'

call plug#end()

""""""""""""""""""
" Fix cursorhold 
"""""""""""""""""
let g:cursorhold_updatetime = 100


""""""""""
" => Largefile
"""""""""
let g:LargeFile=50


""""""""""
" => colorscheme
""""""""""

let g:sonokai_enable_italic=1
let g:sonokai_style="shusia"
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
let g:material_style="darker"
let g:material_dark_float='true'
let g:material_hide_inactive_statusline='true'
let g:material_colors = {"comment": "#696969"}

let g:gruvbox_bold=1
let g:gruvbox_italic=1


" autocmd ColorScheme doom-one highlight Comment gui=italic
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

let g:vista_fzf_preview=['down:69%']
let g:vista_keep_f_colors=1
let g:vista_finder_alternative_executives=['coc', 'ctags']
let g:vista_disable_statusline=1
let g:vista#renderer#ctags='kind'
let g:vista_floating_delay=200




"""""
" => FZF
"""""
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.96, 'relative': v:true, 'yoffset': 0.0 } }
let g:fzf_preview_window = ['down:69%', 'ctrl-/']

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" create file with subdirectories if needed :E
function s:MKDir(...)
    if         !a:0
           \|| stridx('`+', a:1[0])!=-1
           \|| a:1=~#'\v\\@<![ *?[%#]'
           \|| isdirectory(a:1)
           \|| filereadable(a:1)
           \|| isdirectory(fnamemodify(a:1, ':p:h'))
        return
    endif
    return mkdir(fnamemodify(a:1, ':p:h'), 'p')
endfunction
command -bang -bar -nargs=? -complete=file E :call s:MKDir(<f-args>) | e<bang> <args>














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
    execute ":TZMinimalist"
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

""""""""""""""""
" ==> nvim-bufferline
""""""""""""""""
lua require('nvim-bufferline_config')


""""""""""""""""""""""""""""""
" => Coc.nvim
""""""""""""""""""""""""""""""


function! s:DisableFileExplorer()
    au! FileExplorer
endfunction

function! s:OpenDirHere(dir)
    if isdirectory(a:dir)
        let b:cmd = "CocCommand explorer --reveal " . a:dir
        let b:cmd = strpart(b:cmd, 0, strlen(b:cmd) -1)
        exec b:cmd
    endif
endfunction

" Taken from vim-easytree plugin, and changed to use coc-explorer
augroup CocExplorerDefault
    autocmd VimEnter * call <SID>DisableFileExplorer()
    autocmd BufEnter * call <SID>OpenDirHere(expand('%:p'))
augroup end


" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Disable on files > 1mb
autocmd BufAdd * if getfsize(expand('<afile>')) > 1024*1024 |
    \ TSBufDisable highlight
    \ TSBufDisable all
    \ syntax off
    \ IndentGuidesDisable 
    \ let b:coc_enabled=0 
    \ echo "asdfasdf"
    \ endif

" coc-extensions list

let g:coc_global_extensions = [
            \ 'coc-yank',
            \ 'coc-tabnine',
            \ 'coc-snippets',
            \ 'coc-marketplace',
            \ 'coc-html-css-support',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-htmldjango',
            \ 'coc-emoji',
            \ 'coc-calc',
            \ 'coc-explorer',
            \ 'coc-diagnostic',
            \ 'coc-actions',
            \ 'coc-vimtex',
            \ 'coc-vetur',
            \ 'coc-tsserver',
            \ 'coc-toml',
            \ 'coc-sql',
            \ 'coc-sh',
            \ 'coc-rust-analyzer',
            \ 'coc-pyright',
            \ 'coc-lua',
            \ 'coc-json',
            \ 'coc-java',
            \ 'coc-go',
            \ 'coc-fish',
            \ 'coc-clangd',
            \ ]

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
set foldnestmax=10


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
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_default_mapping=0
let g:indent_guides_exclude_filetypes = ['help', 'qf', 'quickfix', 'whichkey', 'WhichKey', 'nofile', 'terminal', 'nofile', "dashboard"]

" Cannot seem to exclude terminals!
au TermEnter * IndentGuidesDisable
au TermLeave * IndentGuidesEnable




"""""""""""""""
" => keybinds
"""""""""""
silent source ~/.config/nvim/keybindings.vim
" The rest of the keybindings can be found in ./lua/which-key_config.lua



"""""""""""""""""""""""""""
" => Assorted Functions
"""""""""""""""""""""""""""""
lua MYFUNC = require('functions')
" Not sure if this is the right way to do it, but it works ?!




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

"""""""""""""""""
" => vim-floaterm
""""""""""""""""""
let g:floaterm_width = 1.0
let g:floaterm_height = 0.420
let g:floaterm_position='bottom'


"""""""""""""""""
" => dashboard-nvim
""""""""""""""""""'
let g:dashboard_default_executive = "fzf"

let g:dashboard_custom_header = [
    \ '',
    \'███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
    \'████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
    \'██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
    \'██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
    \'██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
    \'╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
    \'                                                  ']

" let g:dashboard_custom_shortcut={
" \ 'last_session'       : 'SPC s l',
" \ 'find_history'       : 'SPC s h f',
" \ 'find_file'          : 'SPC f f',
" \ 'new_file'           : 'SPC T n',
" \ 'change_colorscheme' : 'SPC h t',
" \ 'find_word'          : 'SPC s p',
" \ 'book_marks'         : 'SPC l m',
" \ }
" let g:dashboard_custom_shortcut_icon={}

" let g:dashboard_custom_shortcut_icon['last_session'] = ' '
" let g:dashboard_custom_shortcut_icon['find_history'] = 'ﭯ '
" let g:dashboard_custom_shortcut_icon['find_file'] = ' '
" let g:dashboard_custom_shortcut_icon['new_file'] = ' '
" let g:dashboard_custom_shortcut_icon['change_colorscheme'] = ' '
" let g:dashboard_custom_shortcut_icon['find_word'] = ' '
" let g:dashboard_custom_shortcut_icon['book_marks'] = ' '


" let g:dashboard_seperator = "                 "

" let g:dashboard_custom_section={
"   \ 'buffer_list': {
"       \ 'description': [' List Files' . g:dashboard_seperator . 'SPC b b'],
"       \ 'command': 'Files' }
"   \ }



""""""""""""""
" vim-venom
""""""""""""""

let g:venom_use_tools = 1
let g:venom_tools = {
  \ 'poetry': 'poetry env info -p',
  \ 'pipenv': 'pipenv --venv'
  \ }

autocmd User VenomActivated
            \ CocRestart




""""""""""""""
" Private Configuration
""""""""""""""
source ~/dotfiles-private/nvim/projects.vim






""""""""""""""
" Graveyard
""""""""""""""
" source ~/.config/nvim/graveyard.vim














