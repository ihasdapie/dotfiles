
"""""""""""""""""""
"" ==> Graveyard
"""""""""""""""""""


"""""""""""""
" => Indent-Blankline
"""""""""""""""

" let g:indent_blankline_use_treesitter = v:true


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



"""""""""""""
" Ale
"""""""""""""
" let g:ale_fixers = {
"             \'*': ['remove_trailing_lines', 'trim_whitespace'],
"             \ }
" let g:ale_linters={
"             \ 'rust' : ['analyzer'],
"             \ 'python' : ['pyright']
"             \ }
" let g:ale_sign_column_always = 1
" let g:ale_lint_delay = 1000  " Default, 200ms: I don't need linting that much

" let g:ale_disable_lsp = 1
" let g:ale_hover_cursor = 1
" let g:ale_set_balloons =1 " Show hover tooltip in balloon



""""""""""""""""
" ==> Barbar
""""""""""""""""

" " NOTE: If barbar's option dict isn't created yet, create it
" let bufferline = get(g:, 'bufferline', {})

" " Enable/disable animations
" let bufferline.animation = v:false

" " Enable/disable auto-hiding the tab bar when there is a single buffer
" let bufferline.auto_hide = v:true

" " Enable/disable current/total tabpages indicator (top right corner)
" let bufferline.tabpages = v:true

" " Enable/disable close button
" let bufferline.closable = v:true

" " Enables/disable clickable tabs
" "  - left-click: go to buffer
" "  - middle-click: delete buffer
" let bufferline.clickable = v:true

" " Enable/disable icons
" " if set to 'numbers', will show buffer index in the tabline
" " if set to 'both', will show buffer index and icons in the tabline
" let bufferline.icons = v:true

" " Sets the icon's highlight group.
" " If false, will use nvim-web-devicons colors
" let bufferline.icon_custom_colors = v:false

" " Configure icons on the bufferline.
" let bufferline.icon_separator_active = '▎'
" let bufferline.icon_separator_inactive = '▎'
" let bufferline.icon_close_tab = ''
" let bufferline.icon_close_tab_modified = '●'

" " Sets the maximum padding width with which to surround each tab
" let bufferline.maximum_padding = 2

" " If set, the letters for each buffer in buffer-pick mode will be
" " assigned based on their name. Otherwise or in case all letters are
" " already assigned, the behavior is to assign letters in order of
" " usability (see order below)
" let bufferline.semantic_letters = v:true

" " New buffer letters are assigned in this order. This order is
" " optimal for the qwerty keyboard layout but might need adjustement
" " for other layouts.
" let bufferline.letters =
"   \ 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP'

"  Sets the name of unnamed buffers. By default format is "[Buffer X]
" " where X is the buffer number. But only a static string is accepted here.
" let bufferline.no_name_title = v:null


""""""""""""""""""""""""""""""
"" => NerdTree & NerdTreeToggle
"""""""""""""""""""""""""""""""

"let g:NERDTreeWinPos = "right"
"let NERDTreeShowHidden=0
"let NERDTreeIgnore = ['\.pyc$', '__pycache__']
"let g:NERDTreeWinSize=35

