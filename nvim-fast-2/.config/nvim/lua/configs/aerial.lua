-- aerial.nvim — modern symbol outline
-- REPLACES vista.vim. Provides :Vista alias for muscle memory.

require("aerial").setup({
    backends = { "treesitter", "lsp", "markdown", "man" },
    layout = {
        default_direction = "right",
        min_width = 35,
        max_width = { 50, 0.3 },
    },
    show_guides = true,
    autojump = true,
    close_on_select = false,
    filter_kind = false,
    on_attach = function(bufnr)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
})

-- :Vista alias so the user's existing keymaps still work
vim.api.nvim_create_user_command("Vista", function(opts)
    local arg = (opts.args or ""):gsub("!!", "")
    if opts.bang or arg == "" then
        vim.cmd("AerialToggle right")
    elseif arg == "finder" then
        vim.cmd("AerialNavToggle")
    elseif arg == "!" then
        vim.cmd("AerialClose")
    else
        vim.cmd("AerialToggle right")
    end
end, { nargs = "?", bang = true })
