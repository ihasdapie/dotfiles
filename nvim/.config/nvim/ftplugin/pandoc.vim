

" So that you can get vimtex features in markdown & pandoc
" This will look like it fails (hence the silent!) but it will work
silent! call vimtex#init()


" below doens't quite work yet (not compatabile with snippets) 
" What we have to do is make the math() context checker check our syn region
" as well, or to file a PR to vimtex to enable this...
" def math():
"   # TODO: Add support for inline math in markdown katex w/ \\(  \\)
"   return vim.eval('vimtex#syntax#in_mathzone()') == '1'
"
" syn region math start="\\(" end="\\)"                        
" syn match math '\\\\([^$].\{-}\\\\)' 
" hi link math Statement

