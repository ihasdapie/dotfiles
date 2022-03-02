" vim:fileencoding=utf-8:foldmethod=marker

" => General Settings {{{

set guifont=PragmataProMonoLiga\ Nerd\ Font:h16

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
set report=99999 " Increase threshold for reporting number of lines changed
set shortmess=atcF " 'F' gets rid of the annoying echoing filename

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



""" Disable built in plugins {{{
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


""" }}}


" Saner behaviour of `n` and `N`
nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]

nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]
" }}}


call plug#begin('~/.config/nvim/plugged')

" Essentials
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Luxed/ayu-vim'
Plug 'lambdalisue/suda.vim', {'on': ['SudaRead', 'SudaWrite']}
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'lervag/vimtex', {'for': ['tex', 'bib', 'md', 'markdown', 'pdc', 'pandoc'], 'on': ['VimtexInverseSearch', 'VimtexView', 'VimtexCompile']}

call plug#end()
" }}}



": => Colorscheme {{{
let g:ayucolor="mirage" " for mirage version of theme
let g:ayu_italic_comment = 1 " defaults to 0.
let g:ayu_sign_contrast = 1 " defaults to 0. If set to 1, SignColumn and FoldColumn will have a higher contrast instead of using the Normal background
colorscheme ayu
"}}}


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
  let command_fmt = 'rg --column --line-number --no-heading --color=always --follow --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction


command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --follow --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Rg with reload: RG
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=* RgHidden
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --no-heading --color=always --follow --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

silent source ~/.config/nvim/keybindings.vim
" The rest of the keybindings can be found in ./lua/which-key_config.lua



"""""""""""""""""""""""
"=>suda.vim
""""""""""""""""""""""""
let g:suda#prefix = 'suda://'
" multiple protocols can be defined too
let g:suda#prefix = ['suda://', 'sudo://', '_://']



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



" open file in default external program
command! -bang -nargs=* -complete=file Open :silent! !xdg-open <args> &


let mapleader=" "   " leader mappings with SPC
let maplocalleader="," " Although not for 'official' use -- use ',' as a shortcut for some leader actions

nnoremap k gk
nnoremap j gj

vnoremap k gk
vnoremap j gj




"Allow <esc> to exit out of terminal mode
tnoremap <Esc> <C-\><C-n>
" noremap <silent> <c-k> :call smooth_scroll#up(&scroll/2, 0, 2)<CR>
" noremap <silent> <c-j> :call smooth_scroll#down(&scroll/2, 0, 2)<CR>


noremap <silent> <c-k> 15k
noremap <silent> <c-j> 15j
noremap <silent> <c-l> 10l
noremap <silent> <c-h> 10h




vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

vnoremap <LocalLeader>y "+y 
nnoremap <LocalLeader>y "+y 
vnoremap <LocalLeader>p "+p
nnoremap <LocalLeader>p "+p








