" vim:fileencoding=utf-8:foldmethod=marker

" => General Settings {{{

set guifont=FiraCode\ Nerd\ Font:h30
" set guifont=Victor\ Mono\ Bold\ Nerd\ Font\ Complete\ Mono:h30

set rtp+=~/.config/nvim/
set rtp+=~/.config/nvim/lua/

lua require('tmp_init')

filetype plugin on
filetype indent on

set history=500 " Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime " Silent or else `q:` or `q/` get messed up


filetype off
set visualbell
set confirm
set mousemodel=popup_setpos 

set noshowmode "to remove redundant --insert-- etc"
set lazyredraw
set nowrap "turn off wrapping"
set timeoutlen=420

set title titlestring=vim\[%t\]\:%n titlelen=70


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
set pumblend=15 "pseudo-transparency for popup menu

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Allow for glyphs and indentLine
set conceallevel=2

" }}}


" => User Interface {{{
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


let g:loaded_gzip = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1

let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Self-explanatory.
set viewdir=~/dotfiles-private/nvim/view 
augroup remember_folds
  autocmd!
  au BufWinLeave *.*  mkview
  au BufWinEnter *.* silent! loadview
augroup END



" Make quickfix buffers nonlisted
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END


" Map <Ctrl-x> TAB  to vim ommifunc completion
" Useful in cases where coc.nvim isn't around, e.g. when working with
" beancount 
inoremap <C-x><tab> <C-x><C-o>

" Saner behaviour of `n` and `N`
nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]

nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]
" }}}

" => augroups {{{
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
    au! BufNewFile,BufFilePre,BufRead *.pdc set filetype=markdown.pandoc
augroup END


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

" }}}
"

""""""""
" => Polyglot
""""""""""
" Polyglot is slow but it is the best option atm will have to use it...
let g:polyglot_disabled = ['org']
let g:python_highlight_space_errors=0 " Get rid of ugly python red stuff for trailing whitespace



" => vim-plug {{{


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
Plug 'voldikss/vim-floaterm', {'on': ['FloatermFirst', 'FloatermHide', 'FloatermKill',
            \ 'FloatermLast', 'FloatermNew', 'FloatermNext', 'FloatermPrev', 'FloatermSend', 
            \ 'FloatermShow', 'FloatermToggle', 'FloatermUpdate', 'FloatermFirst']}
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kshenoy/vim-signature' 
Plug 'ggandor/lightspeed.nvim'
Plug 'famiu/bufdelete.nvim', {'on': ['Bdelete', 'BWipeout']}
Plug 'mbbill/undotree', {'on': ['UndotreeToggle']}

" Performance improvements
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'tweekmonster/startuptime.vim/', {'on': 'StartupTime'}
Plug 'vim-scripts/LargeFile'
Plug 'famiu/nvim-reload', {'on': ['Reload', 'Restart']}


" Eyecandy
Plug 'kdav5758/TrueZen.nvim', {'on': ['TZMinimalist', 'TZAtaraxis']}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'wfxr/minimap.vim', {'on': ['MinimapToggle']}
Plug 'glepnir/dashboard-nvim'



" Colourschemes
Plug 'gruvbox-community/gruvbox',  {'on': ['Colors']}
Plug 'ihasdapie/spaceducky',  {'on': ['Colors']}
Plug 'navarasu/onedark.nvim', {'on': ['Colors']}
Plug 'b4skyx/serenade', {'on': ['Colors']}
Plug 'Luxed/ayu-vim' 

" Plug 'dracula/vim', {'on': ['Colors']}
" ^^ Dracula seems to break `Colors`  fzf command?
" Plug 'ayu-theme/ayu-vim'
" Plug 'Shatur/neovim-ayu'



" Tools
Plug 'michaelb/sniprun', {'do': 'bash install.sh', 'on': ['SnipRun', ]}
Plug 'b3nj5m1n/kommentary'
Plug 'lambdalisue/suda.vim', {'on': ['SudaRead', 'SudaWrite']}
Plug 'nathanaelkane/vim-indent-guides'
" Plug 'rafi/vim-venom', { 'for': 'python' }
Plug 'DougBeney/pickachu', {'on': ['Pick', 'Pickachu']}
Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-surround'
Plug 'folke/which-key.nvim'
Plug 'ferrine/md-img-paste.vim'
Plug 'mechatroner/rainbow_csv', {'for': ['csv']}
Plug 'kristijanhusak/vim-dadbod-ui', {'on': ['DBUI', 'DB']}
Plug 'tpope/vim-dadbod', {'on': ['DBUI', 'DB']}
Plug 'mg979/vim-visual-multi'

Plug 'nvim-lua/plenary.nvim'
Plug 'kevinhwang91/nvim-bqf'

" Other
Plug 'weirongxu/plantuml-previewer.vim', {'for': 'plantuml'}
Plug 'tyru/open-browser.vim', {'on': ['OpenBrowser',
            \ 'OpenBrowserSearch', 'OpenBrowserSmartSearch']}

" Language Syntax
Plug 'lervag/vimtex', {'for': ['tex', 'bib', 'pdc', 'pandoc']}
Plug 'daeyun/vim-matlab', {'for': ['matlab', 'octave']}
Plug 'liuchengxu/graphviz.vim', {'for': ['dot'] }
Plug 'vim-pandoc/vim-pandoc', {'for': ['pandoc', 'pdc', 'markdown'], 'on': ['Pandoc']}
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': ['pandoc', 'pdc', 'md', 'markdown'], 'on': ['Pandoc']}

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground', {'on': ['TSPlaygroundToggle']}
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'p00f/nvim-ts-rainbow'


" Experimental

" Plug '~/Projects/vim-dev/SCHLAD-list.nvim', {'for': ['markdown', 'txt', 'org']}

Plug 'kristijanhusak/orgmode.nvim', {'for': ['org'], 'branch': 'tree-sitter'}
Plug '~/Projects/vim-dev/nvim-bufferline.lua'
Plug 'nathangrigg/vim-beancount', {'for': ['beancount']}
Plug 'sindrets/winshift.nvim', {'on': ['WinShift']}
" Plug 'edluffy/hologram.nvim'


" Debugger

Plug 'puremourning/vimspector', {'on': ['<Plug>VimspectorContinue',
            \ '<Plug>VimspectorBalloonEval', 'AbortInstall', 'DebugInfo', 'Install', 'Reset',
            \ 'ShowOutput', 'ToggleLog', 'Update', 'Watch']}

call plug#end()
" }}}




": => Colorscheme {{{
let g:gruvbox_bold=1
let g:gruvbox_italic=1

let g:ayucolor="mirage" " for mirage version of theme
let g:ayu_italic_comment = 1 " defaults to 0.
let g:ayu_sign_contrast = 1 " defaults to 0. If set to 1, SignColumn and FoldColumn will have a higher contrast instead of using the Normal background

colorscheme ayu

"}}}

" => Vista {{{

" let g:vista_icon_indent = ["╰─▶ ", "├─▶ "] 
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

" }}}

" => FZF {{{
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



" }}}


" => Coc.nvim {{{

" Signature help is really useful :)
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp') 
" If it gets annoying, try this mapping:
" inoremap <silent><localleader>s call CocActionAsync('showSignatureHelp')<CR>


" Tab completion
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" C-space to show completion list again
inoremap <silent><expr> <c-space> coc#refresh()

xnoremap <leader>cF  <Plug>(coc-format-selected)
nnoremap <leader>cF  <Plug>(coc-format-selected)

" KK to show function docs in floating
nnoremap <silent>KK :call <SID>show_documentation()<CR>
" K to split out function docs in bottom buffer
nnoremap <silent>K :call ShowDoc()<CR><C-e>

" Use C-enter to select instead (so it doesn't mess up entering a newline at times)
inoremap <silent><expr> <C-enter> pumvisible() ? coc#_select_confirm() : "\ijj>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Coc Functions {{{
function! s:check_back_space() abort
    let col = col('.') - 1
return !col || getline('.')[col - 1]  =~# '\s'
endfunction


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


function! ShowDoc() abort
  let winid = get(g:, 'coc_last_float_win', -1)
  if winid != -1
    let bufnr = winbufnr(winid)
    exe 'below sb '.bufnr
    exe 'close '.winid
  endif
  return ''
endfunction



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

" Disable on files > 1mb
autocmd BufAdd * if getfsize(expand('<afile>')) > 1024*1024 |
    \ TSBufDisable highlight
    \ TSBufDisable all
    \ syntax off
    \ IndentGuidesDisable 
    \ let b:coc_enabled=0 
    \ endif

" Opens coc-definition in a new split if it isn't already opened.
" TODO: Give option for floating.
function! SplitIfNotOpen(...)
    let fname = a:1
    let call = ''
    if a:0 == 2
	let fname = a:2
	let call = a:1
    endif
    let bufnum=bufnr(expand(fname))
    let winnum=bufwinnr(bufnum)
    if winnum != -1
	" Jump to existing split
	exe winnum . "wincmd w"
    else
	" Make new split as usual
	exe "vsplit " . fname
    endif
    " Execute the cursor movement command
    exe call
endfunction
command! -nargs=+ CocSplitIfNotOpen :call SplitIfNotOpen(<f-args>)

" }}}

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
            \ 'coc-db'
            \ ]



" }}}

" => Personal Functions {{{

" => Toggle Transparent Background
let t:is_transparent = 1
function! Toggle_transparent()
    if t:is_transparent == 0
        hi Normal ctermbg=black
        set background=dark
        execute "colorscheme " .. g:prev_colorscheme

        let t:is_transparent = 1
        echo "Transparency on" 
    else
        hi Normal guibg=NONE ctermbg=NONE
        let t:is_transparent = 0
        let g:prev_colorscheme = g:colors_name
        echo "Transparency on" 
    endif
endfunction

" Focus mode
function! Prose_mode()
    execute ":TZMinimalist"
    execute ":set linebreak"
    execute ":set wrap"
endfunction





" => Scratch Buffer
function! Scratch()
    vsplit
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    "setlocal nobuflisted
    "lcd ~
    file scratch
endfunction

" }}}

" => Lua Configurations {{{

" lua require('plugins')
" lua require('impatient')
lua require('galaxyline_config')
lua require('nvim-bufferline_config')
lua require('which-key_config')
lua require('gitsigns_config')

" Since neorg defines a treesitter parser, we must run this before our
" treesitter setup()
" lua require('neorg_config')  

lua require('treesitter_config')
lua require('vimtex_bindings')

" lua require('todo-comments_config')
" lua require('telescope_config')

" }}}


" -> Orgmode.nvim {{{


"  }}}


" => Treesitter {{{
set nofoldenable
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldnestmax=10
" }}}
lua require('orgmode-nvim_config')


" => dadbod {{{

let g:db_ui_use_nerd_fonts=1
let g:db_ui_show_database_icon=1
let g:db_ui_auto_execute_table_helpers=1
" let g:db_ui_disable_mappings=1 " need to which-key map!



" }}}

" => Unorganized {{{
 

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
let g:indent_guides_exclude_filetypes = ['help', 'qf', 'quickfix', 'whichkey', 'WhichKey', 'nofile', 'terminal', 'nofile', "dashboard", "term"]

" terminal ft doesn't seem to exclude?
" au TermEnter * IndentGuidesDisable
" au TermLeave * IndentGuidesEnable


""""""""""""""""""""""""
" => Indentline
 """"""""""""
" let g:indent_blankline_use_treesitter = v:true
" let g:indentLine_fileType = ['help', 'qf', 'quickfix', 'whichkey', 'WhichKey', 'nofile', 'terminal', 'nofile', "dashboard"]
" => keybinds
"""""""""""
silent source ~/.config/nvim/keybindings.vim
" The rest of the keybindings can be found in ./lua/which-key_config.lua



"""""""""""""""""""""""""""
" => Assorted Functions
"""""""""""""""""""""""""""""
lua MYFUNC = require('functions')
" Not sure if this is the right way to do it, but it works ?!





""""""""""""""""""""""
" => Rainbow csv
""""""""""""""'
let g:disable_rainbow_key_mappings = 1


""""""
" csv.vim
"""""""""
let g:csv_nomap_cr = 1
let g:csv_nomap_space = 1

"""""""""""""""""
" => vim-floaterm
""""""""""""""""""
let g:floaterm_width = 1.0
let g:floaterm_height = 0.420
let g:floaterm_position='bottom'


"""""""""""""""""
" => dashboard-nvim
""""""""""""""""""'
lua require('dashboard_config')


""""""""""""""
" vim-venom
""""""""""""""

" This absolutely massacres startup time for repo without virtualenv...
" let g:venom_use_tools = 1
" let g:venom_tools = { 'poetry': 'poetry env info -p'}
" autocmd User VenomActivated CocRestart

""""""""""""""""
" => Pandoc
""""""""""""""""
let g:pandoc#syntax#codeblocks#embeds#langs = ['python', 'tex', 'rust', 'c', 'cpp', 'lua', 'matlab']



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

let g:vimtex_compiler_latexmk = {
            \ 'build_dir' : '',
            \ 'callback' : 1,
            \ 'continuous' : 1,
            \ 'executable' : 'latexmk',
            \ 'hooks' : [],
            \ 'options' : [
                \   '-verbose',
                \   '-file-line-error',
                \   '-synctex=1',
                \   '-interaction=nonstopmode',
                \   '-shell-escape'
                \ ],
                \}

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



""""""""""""""""""
" Fix cursorhold 
""""""""""""""""" let g:cursorhold_updatetime = 100

""""""""""
" => Largefile
"""""""""
let g:LargeFile=50

 
 
" }}}


""""""""""""""
" Private Configuration
""""""""""""""
source ~/dotfiles-private/nvim/private.vim




"""""""""""""""
" Lightspeed.nvim
"""""""""""""""

" make `f`, `t` work as per normal in macros
" Issue will be resolved soon, https://github.com/ggandor/lightspeed.nvim/issues/14
nmap <expr> f reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"
nmap <expr> F reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"
nmap <expr> t reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"
nmap <expr> T reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"


" => Wilder.nvim {{{

call wilder#setup({'modes': [':', '/', '?'],
      \ 'next_key': '<Tab>',
      \ 'previous_key': '<S-Tab>',
      \ })

call wilder#set_option('use_python_remote_plugin', 0)



autocmd CmdlineEnter * ++once call s:wilder_init()

function! s:wilder_init() abort

    call wilder#set_option('pipeline', [
                \   wilder#branch(
                \     wilder#cmdline_pipeline({
                \       'use_python': 0, 
                \       'fuzzy': 0, 
                \     }),
                \     wilder#vim_search_pipeline(),
                \   ),
                \ ])

    call wilder#set_option('renderer', wilder#renderer_mux({
                \ ':': wilder#popupmenu_renderer({
                \   'highlighter': wilder#basic_highlighter(),
                \   'left': [
                    \     wilder#popupmenu_devicons(),
                    \   ]
                        \ }),
                        \ '/': wilder#wildmenu_renderer({
                        \   'highlighter': wilder#basic_highlighter(),
                        \ }),
                        \ }))

endfunction






" }}}

