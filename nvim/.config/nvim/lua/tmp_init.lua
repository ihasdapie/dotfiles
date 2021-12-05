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


--[[
local function M.add_rtp(path)
  local rtp = vim.o.rtp ]]

--[[
vim.api.nvim_exec("set rtp+=~/.config/nvim/lua")
vim.api.nvim_exec("set rtp+=~/.config/nvim/") ]]

-- }}}






