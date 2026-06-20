-- conform.nvim — formatting. Replaces coc-prettier + python.formatting=ruff.

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        rust = { "rustfmt" },
        go = { "gofmt", "goimports" },
        sh = { "shfmt" },
        toml = { "taplo" },
        sql = { "sqlfmt" },
    },
    -- format_after_save runs ASYNCHRONOUSLY post-:w. format_on_save would
    -- block the save until the formatter returned (or hit timeout_ms),
    -- which made every save of yaml/json/md/html/etc. wait ~1500ms when
    -- prettierd/prettier weren't installed and conform fell back through
    -- the chain into LSP formatting. Async means :w returns instantly and
    -- the formatter writes the file in the background.
    --
    -- Keep lsp_fallback off here too: lspconfig's textDocument/formatting
    -- request is what was timing out before. If you actually want LSP-only
    -- format on a buffer, use :Format manually.
    format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 500, lsp_fallback = false }
    end,
})

vim.api.nvim_create_user_command("Format", function(args)
    require("conform").format({
        async = false, lsp_fallback = true,
        range = (args.range == 2) and {
            ["start"] = { args.line1, 0 },
            ["end"]   = { args.line2, 999 },
        } or nil,
    })
end, { desc = "Format buffer (replaces :Format from coc)", range = true })

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then vim.b.disable_autoformat = true
    else vim.g.disable_autoformat = true end
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })
