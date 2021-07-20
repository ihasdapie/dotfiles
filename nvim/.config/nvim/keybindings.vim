"""""""""""""""""""""""""""""""""""""'
" => [M]isc
"""""""""""""""""""""""""""""""""""""'
let mapleader=" "   " leader mappings with SPC
let maplocalleader="," " Although not for 'official' use -- use ',' as a shortcut for some leader actions


"Emacs-like M-x
nnoremap <M-x> :Commands <CR> 

nnoremap <leader>sR :CocSearch

nnoremap k gk
nnoremap j gj

"Allow <esc> to exit out of terminal mode
tnoremap <Esc> <C-\><C-n>
noremap <silent> <c-k> :call smooth_scroll#up(&scroll/2, 0, 2)<CR>
noremap <silent> <c-j> :call smooth_scroll#down(&scroll/2, 0, 2)<CR>
" use *, # to cycle through instances of current word
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" coc.nvim goodies
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

" use <C-enter> to select coc suggestions
inoremap <silent><expr> <C-enter> pumvisible() ? coc#_select_confirm() : "\ijj>u\<CR>\<c-r>=coc#on_enter()\<CR>"


"""""""""""""""""""""""""""""""""""""'
" => [O]pen
"""""""""""""""""""""""""""""""""""""'
nnoremap <silent><leader>op :CocCommand explorer <CR>
nmap <silent> <leader>ovv :Vista!! <cr>
nmap <silent> <leader>ovf :Vista finder <cr>



"""""""""""""""""""""""""""""""""""""'
" => [B]uffers
"""""""""""""""""""""""""""""""""""""'



"""""""""""""""""""""""""""""""""""""'
" => [T]abs: tabs
"""""""""""""""""""""""""""""""""""""'

"""""""""""""""""""""""""""""""""""""'
" => [C]ode: code
"""""""""""""""""""""""""""""""""""""'
nnoremap <leader>cdf :CocList diagnostics<cr>
nnoremap <leader>cdl :CocDiagnostics <cr>
nnoremap <leader>clc :CocList commands<cr>
nnoremap <leader>clo :CocList outline<cr>
nnoremap <leader>cls :CocList symbols<cr>
nnoremap <leader>cfx :CocFix<cr>
nmap <leader>crn <Plug>(coc-rename)

xmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)

nnoremap <leader>csr :SnipRun<CR>
vnoremap <leader>csr :SnipRun<CR>

nnoremap <leader>cmr :MatlabCliRunCell <cr>
nnoremap <leader>cgv :w <CR> :GraphvizCompile <CR>
nnoremap <leader>clf :w<cr> :luafile %<cr>


"""""""""""""""""""""""""""""""""""""'
" => [T]oggle: toggle
"""""""""""""""""""""""""""""""""""""'
noremap <leader>tcb :set clipboard+=unnamedplus<cr>



"""""""""""""""""""""""""""""""""""""'
" => [G]it: git
"""""""""""""""""""""""""""""""""""""'
nnoremap <silent> <leader>gc :Commits <CR>
nnoremap <silent> <leader>gG :Git <CR>



"""""""""""""""""""""""""""""""""""""'
" => [H]elp: help
"""""""""""""""""""""""""""""""""""""'


"""""""""""""""""""""""""""""""""""""'
" => [L]ist: list
"""""""""""""""""""""""""""""""""""""'




" Can't seem to map this one in which-key.nvim
vnoremap <LocalLeader>y "+y 











nnoremap <leader>ps "+p
map <leader>cf :copen <cr>
" map <leader>b :b
" map <leader>bd :bd<cr>:tabclose<cr>gT
" map <leader>l :bnext<cr>
" map <leader>h :bprevious<cr>
" " Useful mappings for managing tabs
" map <leader>tn :tabnew<cr>
" map <leader>to :tabonly<cr>
" map <leader>tc :tabclose<cr>
" map <leader>tm :tabmove
" map <leader>t<leader> :tabnext
" map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/
"
"
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" autocmd FileType vista,vista_kind nnoremap <buffer> <silent> \
nnoremap <leader>ml :Marks <CR>
nnoremap <leader>hf :History <CR>
nnoremap <leader>hc :History: <CR>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)

" Remove trailing whitespace
" nnoremap <leader>ss :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:noh<CR> 


nnoremap <silent> <c-t> :NnnPicker %:p:h<cr>
noremap <leader>md :MundoToggle <cr>



" turn off highlights

noremap <leader>cb :set clipboard+=unnamedplus<cr>
nnoremap <leader>ps "+p


nmap <leader>cf :copen <cr>


noremap <leader>pi :call mdip#MarkdownClipboardImage() <cr>






