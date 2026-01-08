-- vim:fileencoding=utf-8:foldmethod=marker
local M = {}


-- => General Settings {{{
vim.o.number = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cursorline = true
-- vim.o.history = 500
vim.o.mouse='a'

vim.g.did_load_filetypes = 1

vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

--[[
local function M.add_rtp(path)
  local rtp = vim.o.rtp ]]

--[[
vim.api.nvim_exec("set rtp+=~/.config/nvim/lua")
vim.api.nvim_exec("set rtp+=~/.config/nvim/") ]]

-- }}}




-- disable neovide animations
--[[ vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00 ]]
