-- LuaSnip — snippet engine. Replaces coc-snippets.

local luasnip = require("luasnip")

luasnip.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
            active = { virt_text = { { "●", "WarningMsg" } } },
        },
    },
})

-- 1. friendly-snippets (vscode-format, modern, broad coverage).
require("luasnip.loaders.from_vscode").lazy_load()

-- 2. honza/vim-snippets (the snipmate-format dir). LuaSnip loads these
--    natively. The UltiSnips/ dir is loaded by the UltiSnips engine — see
--    lua/plugins/lsp.lua and lua/configs/ultisnips.lua. Together these
--    reproduce what coc-snippets gave you (UltiSnips format) plus parity
--    with snipmate-format collections.
local vim_snippets_dir = vim.env.HOME .. "/.config/nvim-arm/plugged/vim-snippets"
if vim.fn.isdirectory(vim_snippets_dir .. "/snippets") == 1 then
    require("luasnip.loaders.from_snipmate").lazy_load({
        paths = { vim_snippets_dir .. "/snippets" },
    })
end

-- 3. User-authored snippets under nvim-arm/snippets/ (if any).
local user_snip_dir = vim.env.HOME .. "/.config/nvim-arm/snippets"
if vim.fn.isdirectory(user_snip_dir) == 1 then
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { user_snip_dir } })
    require("luasnip.loaders.from_snipmate").lazy_load({ paths = { user_snip_dir } })
end

-- Replicate <Plug>(coc-snippets-expand-jump) on <C-j>
vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
end, { silent = true, desc = "Expand or jump snippet" })
