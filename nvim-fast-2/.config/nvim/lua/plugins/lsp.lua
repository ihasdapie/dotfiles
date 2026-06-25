-- Native LSP stack — REPLACES coc.nvim
--   nvim-lspconfig + mason for server install/management
--   nvim-cmp + sources + LuaSnip for completion + snippets
--   conform.nvim for formatting (replaces coc-prettier / python.formatting)
--   nvim-lint for linting

return {
    -- 1. LSP server installer / manager
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog" },
        build = ":MasonUpdate",
        config = function()
            require("mason").setup({
                ui = { border = "rounded" },
                install_root_dir = vim.fn.stdpath("data") .. "/mason",
            })
        end,
    },

    -- 2. mason ↔ lspconfig bridge (auto-install + auto-setup servers)
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function() require("configs.lsp") end,
    },

    -- 3. LSP configurations
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
    },

    -- 4. Snippet engines — REPLACES coc-snippets.
    --    LuaSnip handles vscode + snipmate format (friendly-snippets +
    --    vim-snippets/snippets/). UltiSnips handles UltiSnips format
    --    (vim-snippets/UltiSnips/) — coc-snippets used UltiSnips internally,
    --    so this preserves every snippet Brian had access to.
    {
        "L3MON4D3/LuaSnip",
        event = "VeryLazy",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function() require("configs.luasnip") end,
    },
    {
        "SirVer/ultisnips",
        event = "VeryLazy",
        init = function()
            -- UltiSnips scans every runtimepath entry for a child dir named
            -- "UltiSnips" (or whatever's in g:UltiSnipsSnippetDirectories).
            -- ~/.config/nvim-fast-2/ is already on the rtp via stdpath, so
            -- a symlink from ~/.config/nvim-fast-2/UltiSnips →
            -- ~/.config/nvim-arm/plugged/vim-snippets/UltiSnips makes
            -- everything Just Work without us touching rtp ourselves
            -- (which previously triggered lazy.nvim's "Found paths from
            -- another plugin manager `plugged`" error).
            vim.g.UltiSnipsExpandTrigger          = "<Plug>(ultisnips_expand)"
            vim.g.UltiSnipsJumpForwardTrigger     = "<Plug>(ultisnips_jump_forward)"
            vim.g.UltiSnipsJumpBackwardTrigger    = "<Plug>(ultisnips_jump_backward)"
            vim.g.UltiSnipsListSnippets           = "<Plug>(ultisnips_list)"
            vim.g.UltiSnipsRemoveSelectModeMappings = 0
            vim.g.UltiSnipsSnippetDirectories     = { "UltiSnips" }
        end,
    },

    -- 5. Completion engine — REPLACES coc#pum / coc-source-*
    {
        "hrsh7th/nvim-cmp",
        event = { "VeryLazy", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "quangnguyen30192/cmp-nvim-ultisnips",
            "hrsh7th/cmp-emoji",
            "onsails/lspkind.nvim",
        },
        config = function() require("configs.cmp") end,
    },

    -- 6. Formatting — REPLACES coc.preferences.formatOnSave
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo", "Format" },
        config = function() require("configs.conform") end,
    },

    -- 7. Linting (keep light; LSP diagnostics cover most cases)
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost", "InsertLeave" },
        config = function() require("configs.lint") end,
    },

    -- 8. Lua type-aware editing for nvim API (only matters in lua files)
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- 9. Yank ring — REPLACES coc-yank
    {
        "gbprod/yanky.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ring = { history_length = 100, storage = "shada" },
        },
        keys = {
            { "<leader>y", "<cmd>YankyRingHistory<cr>", desc = "Yank history" },
        },
    },
}
