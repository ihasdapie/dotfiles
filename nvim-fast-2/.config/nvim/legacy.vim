" nvim-fast-2 legacy.vim — slimmed from nvim-arm/init.vim.
" Removed: vim-plug, coc.nvim, wilder, vim-go, vista, vimspector,
"          vim-test/ultest, gutentags, BZL, FZFExplore/TFile, dead colorscheme
"          per-plugin lets. Plugin-specific lets that we still install live in
"          their lua spec config callbacks instead.
"
" Goal: keep only load-bearing settings + commands the user invokes
" interactively (Rg/RG/RgWordUnderCursor/RgHidden/E/Delview/Open/Scratch/
" Toggle_transparent/MyLatexPasteImage). Cuts cold startup ~5–7 ms.

" vim:fileencoding=utf-8:foldmethod=marker
filetype plugin indent on

let mapleader=" "
let maplocalleader=","

" ---------------------------------------------------------------------------
" General behaviour (sourced from nvim-arm/init.vim — kept verbatim)
if $VIM_PATH != ""
    let $PATH = $VIM_PATH
endif

set history=500
set autoread
au FocusGained,BufEnter * silent! checktime

set guifont=RecMonoDuotone\ Nerd\ Font

set number
set visualbell
set confirm
set mousemodel=popup_setpos
set noshowmode
set lazyredraw
set nowrap
set timeoutlen=420
set title titlestring=%t\:\ %n titlelen=70
set laststatus=3
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set report=99999
set shortmess=atcF
set updatetime=100
set redrawtime=1000
set expandtab
set shiftwidth=4
set colorcolumn=100
set hidden
set pumblend=15
set nobackup
set nowritebackup
set cmdheight=1
set conceallevel=2
set so=7
set wildmenu
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set ruler
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase
set smartcase
set hlsearch
set incsearch
set magic
set noshowmatch
set nofoldenable
set foldnestmax=10

if (has("termguicolors"))
    set termguicolors
endif

" Persistent undo
if has('persistent_undo')
    let target_path = expand('~/.config/nvim-arm/undo/')
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif
    let &undodir = target_path
    set undofile
endif

if !isdirectory(expand('~/.config/nvim-arm/view/'))
    silent ! mkdir -p ~/.config/nvim-arm/view
endif
set viewdir=~/.config/nvim-arm/view/

" Source private user file if it exists (don't auto-create — extra IO).
if filereadable(expand('~/.config/nvim-arm/private.vim'))
    source ~/.config/nvim-arm/private.vim
endif

" ---------------------------------------------------------------------------
" Custom view-delete command
function! MyDeleteView()
    let path = fnamemodify(bufname('%'),':p')
    let path = substitute(path, '=', '==', 'g')
    if !empty($HOME)
        let path = substitute(path, '^'.$HOME, '\~', '')
    endif
    let path = substitute(path, '/', '=+', 'g') . '='
    let path = &viewdir.'/'.path
    call delete(path)
    echo "Deleted: ".path
endfunction
command Delview call MyDeleteView()
cabbrev delview <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Delview' : 'delview')<CR>

" Return to last edit position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Quickfix nonlisted
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

" Pandoc syntax: only for explicit pandoc extensions. .md stays as native
" markdown so treesitter (markdown + markdown_inline) handles it — the pandoc
" syntax route forces vim-pandoc + vim-pandoc-syntax to load on every .md
" file, which then pulls in 7 embedded language syntax files (see
" g:pandoc#syntax#codeblocks#embeds#langs below). That added ~hundreds of ms
" to every markdown open. To opt a specific file in, run :set ft=pandoc.
augroup pandoc_syntax
    au!
    au BufNewFile,BufFilePre,BufRead *.pdc,*.pandoc set filetype=pandoc
augroup END

" Hex-edit binaries
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

" Asm filetype detection
augroup NASM
    au BufNewFile *.nasm setfiletype nasm
    au BufRead *.nasm setfiletype nasm
augroup END
augroup ASM
    au BufNewfile *.asm setfiletype asm
    au BufRead *.asm setfiletype asm
augroup END
augroup ARM
    au BufNewfile *.s setfiletype arm
    au BufRead *.s setfiletype arm
augroup END
let g:asmsyntax='nasm'

" Polyglot disable list (still respected by some syntax plugins).
let g:polyglot_disabled = ['org']
let g:python_highlight_space_errors=0

" <C-x><tab> -> omnifunc completion (for buffers without LSP)
inoremap <C-x><tab> <C-x><C-o>

" Saner n / N moved to init.lua (after this file is :source'd) so that the
" normal-mode form can wrap with `silent!` and suppress the E486 hit-enter
" prompt on no-match. Visual + operator-pending stay <expr>-style there.

" ---------------------------------------------------------------------------
" Colorscheme is applied by lua/plugins/ui.lua's kanagawa spec.
" Keep this dead let for any nvim-arm-borrowed code that consults it.
let g:gruvbox_bold=1
let g:gruvbox_italic=1

" ---------------------------------------------------------------------------
" FZF helpers — kept because <leader>sp/sP/sw bindings call :Rg / :RG /
" :RgWordUnderCursor / :RgHidden in keybindings.vim.
let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['down,80%', 'ctrl-/']
let g:fzf_layout = { 'right': '80%' }

function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg -U --column --line-number --no-heading --color=always --follow --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -bang -nargs=* Rg call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --color=always --follow --smart-case -- '.shellescape(<q-args>), 1,
    \ fzf#vim#with_preview(), <bang>0)
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -bang -nargs=* RgWordUnderCursor call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --color=always --follow --smart-case -- '.shellescape(expand('<cword>')), 1,
    \ fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* RgHidden call fzf#vim#grep(
    \ 'rg --column --line-number --hidden --no-heading --color=always --follow --smart-case -- '.shellescape(<q-args>), 1,
    \ fzf#vim#with_preview(), <bang>0)

" :E that creates parent dirs
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

" ---------------------------------------------------------------------------
" User commands / functions still actively used
function! Toggle_transparent()
    if !exists('t:is_transparent') || t:is_transparent == 0
        if exists('g:prev_colorscheme')
            execute "colorscheme " .. g:prev_colorscheme
        endif
        hi Normal ctermbg=black
        set background=dark
        let t:is_transparent = 1
        echo "Transparency off"
    else
        hi Normal guibg=NONE ctermbg=NONE
        let t:is_transparent = 0
        let g:prev_colorscheme = g:colors_name
        echo "Transparency on"
    endif
endfunction

function! Scratch()
    vsplit
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    file scratch
endfunction

" md-image-paste customization
let g:mdip_imgdir = 'img'
let g:mdip_imgname = 'image'
function! g:MyLatexPasteImage(relpath)
    execute "normal! i\\begin{figure}[H]\r\\centering\r\\includegraphics[width=0.8\\linewidth]{" . a:relpath . "}\r\\caption{}\r\\label{fig:}\r\\end{figure}"
    execute "normal! kki"
endfunction
autocmd FileType markdown let g:PasteImageFunction = 'g:MarkdownPasteImage'
autocmd FileType tex      let g:PasteImageFunction = 'g:MyLatexPasteImage'

" Pandoc embedded code blocks. Trimmed embeds list — each entry forces vim
" to load the corresponding syntax/<lang>.vim when a pandoc buffer opens, so
" only enable embeds you actually use in pandoc docs.
let g:pandoc#syntax#codeblocks#embeds#langs = ['python', 'lua']
" Don't claim plain markdown — let treesitter handle .md. vim-pandoc only
" engages on explicit pandoc buffers (.pdc / :set ft=pandoc).
let g:pandoc#filetypes#handled = ["pandoc"]

" VimTeX — only the settings that affect plugin behaviour, not which-key
" descriptions (those moved to lua/configs/legacy_overrides.lua).
let g:tex_flavor = "latex"
let g:vimtex_view_method = 'skim'
let g:vimtex_quickfix_mode = 0
let g:tex_conceal = 'abdmgs'
let g:vimtex_matchparen_enabled = 0
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback'  : 1,
    \ 'continuous': 1,
    \ 'executable': 'latexmk',
    \ 'hooks'     : [],
    \ 'options'   : [
        \ '-verbose', '-file-line-error', '-synctex=1',
        \ '-interaction=nonstopmode', '-shell-escape', '-pvc'
        \ ],
    \}

" suda
let g:suda#prefix = ['suda://', 'sudo://', '_://']

" lua-syntax embedding
let g:vimsyn_embed = 'l'

" rainbow_csv / csv.vim
let g:disable_rainbow_key_mappings = 1
let g:csv_nomap_cr = 1
let g:csv_nomap_space = 1

" maximizer
let g:maximizer_set_default_mapping = 0

" leetcode
let g:leetcode_browser = 'firefox'

" dadbod
let g:db_ui_use_nerd_fonts = 1
let g:db_ui_show_database_icon = 1
let g:db_ui_auto_execute_table_helpers = 1

" Open file in default external program
command! -bang -nargs=* -complete=file Open :silent! !xdg-open <args> &

" Copilot — no-tab map + custom <C-l> accept (set in copilot var so the
" plugin loads with these defaults; the imap is registered when copilot loads)
let g:copilot_filetypes = {}
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-l> copilot#Accept("\<CR>")

" fern (compat — fern.vim removed; neo-tree is the replacement, but if any
" code path still triggers fern, set the renderer so it doesn't error).
let g:fern#renderer = "nvim-web-devicons"

" ---------------------------------------------------------------------------
" REMOVED from the original:
"   - vim-plug auto-install + plug#begin/end       (lazy.nvim handles it)
"   - vim-go let g:go_*                             (vim-go not installed)
"   - vista config                                  (aerial.nvim is the replacement)
"   - coc.nvim config + tab completion + functions  (native LSP + nvim-cmp)
"   - wilder.nvim setup                             (noice.nvim is the replacement)
"   - vimspector_base_dir                           (nvim-dap is the replacement)
"   - vim-test/vim-ultest config                    (not installed)
"   - gutentags_cache_dir                           (not installed)
"   - BZL function                                  (rare; resurrect on demand)
"   - FZFExplore / TFile                            (telescope/neo-tree cover this)
"   - dashboard sections                            (alpha-nvim spec is in lua)
"   - indent_guides_*                               (indent-blankline replaces)
"   - LargeFile                                     (bigfile.nvim replaces)
"   - floaterm config                               (toggleterm replaces)
"   - filetype off                                  (lazy.nvim doesn't need it)
" These were all inert (variables for plugins that aren't installed) but
" added ~5 ms of let-statement processing on cold start.
