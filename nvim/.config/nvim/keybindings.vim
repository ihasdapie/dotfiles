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

vnoremap k gk
vnoremap j gj


""" Coc-snippets
imap <C-j> <Plug>(coc-snippets-expand-jump)


"Allow <esc> to exit out of terminal mode
tnoremap <Esc> <C-\><C-n>
" noremap <silent> <c-k> :call smooth_scroll#up(&scroll/2, 0, 2)<CR>
" noremap <silent> <c-j> :call smooth_scroll#down(&scroll/2, 0, 2)<CR>


noremap <silent> <c-k> 15k
noremap <silent> <c-j> 15j
noremap <silent> <c-l> 10l
noremap <silent> <c-h> 10h



" use *, # to cycle through instances of current word
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


nnoremap <leader>cmr :MatlabCliRunCell <cr>
nnoremap <leader>cgv :w <CR> :GraphvizCompile <CR>
nnoremap <leader>clf :w<cr> :luafile %<cr>

" Can't seem to map this one in which-key.nvim
vnoremap <LocalLeader>y "+y 
" map <leader>cf :copen <cr>
"
"
"
"
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


vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>cqf  <Plug>(coc-fix-current)

" Remove trailing whitespace
" nnoremap <leader>ss :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:noh<CR> 




nmap <leader>cf :copen <cr>

" turn off highlights





noremap <leader>pi :call mdip#MarkdownClipboardImage() <cr>






