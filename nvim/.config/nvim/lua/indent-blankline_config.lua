
--[[ vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_buftype_exclude = { 'help', 'qf', 'quickfix', 'whichkey', 'WhichKey', 'nofile', 'terminal', 'nofile', "dashboard", 'dash', 'nofile'}

require("indent_blankline").setup {
    show_current_context = true,
    filetype_exclude = {'dashboard', 'help'},
    buftype_exclude = { 'help', 'qf', 'quickfix', 'whichkey', 'WhichKey', 'nofile', 'terminal', 'nofile', "dashboard", 'dash', 'nofile'}
}

 ]]
