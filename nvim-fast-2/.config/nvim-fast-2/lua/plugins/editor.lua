-- Editor enhancements: surround, repeat, autopairs, comment, marks, multi-cursor,
-- which-key, flash/leap, indent guides

return {
    -- Which-key (keymap discovery) — load slightly after VimEnter
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function() require("which-key_config") end,
    },

    -- Autopairs — preload after UI paint instead of first InsertEnter so it
    -- doesn't add to the first-insert lag spike (was the last InsertEnter
    -- holdout after copilot/cmp/luasnip/ultisnips moved to VeryLazy).
    {
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        config = function() require("nvim-autopairs_config") end,
    },

    -- Surround
    { "tpope/vim-surround", keys = { "ys", "cs", "ds", { "S", mode = "v" } } },

    -- Repeat
    { "tpope/vim-repeat", event = "VeryLazy" },

    -- Commenting — REPLACES kommentary (abandoned, Sep 2022)
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "v" } },
            { "gcc", mode = "n" },
            { "gbc", mode = "n" },
        },
        config = function() require("Comment").setup() end,
    },

    -- Marks signs in gutter — REPLACES kshenoy/vim-signature
    {
        "chentoast/marks.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function() require("configs.marks") end,
    },

    -- Color highlighting — REPLACES chrisbra/Colorizer (vimscript)
    {
        "catgoose/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        config = function() require("configs.colorizer") end,
    },

    -- Multi-cursor (no Lua replacement that's stable yet — keep VM)
    { "mg979/vim-visual-multi", keys = { "<C-n>", "<C-d>", "<C-Up>", "<C-Down>" } },

    -- Quickfix UI
    { "kevinhwang91/nvim-bqf", ft = "qf" },

    -- Flash (jump motion). search.enabled=false so `/` is plain vim search
    -- (no label overlay) — combined with the cmap dance in init.lua, the
    -- overlay made `<CR>` land on the 2nd match and repaint the cmdline.
    {
        "folke/flash.nvim",
        keys = {
            { "s", mode = { "n", "x", "o" } },
            { "S", mode = { "n", "x", "o" } },
            { "r", mode = "o" },
            { "R", mode = { "o", "x" } },
        },
        opts = {
            modes = {
                search = { enabled = false },
                char   = { enabled = true },
            },
        },
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
        config = function() require("indent-blankline_config") end,
    },

    -- Easy align
    {
        "junegunn/vim-easy-align",
        keys = { { "ga", mode = { "n", "x" } } },
    },

    -- vim-snippets — we DON'T need the lazy clone of this. LuaSnip's snipmate
    -- loader and UltiSnips both read directly from ~/.config/nvim-arm/plugged/
    -- vim-snippets/, so the clone at /tmp/.../lazy/vim-snippets is redundant
    -- and its plugin/vimsnippets.vim was loading eagerly at startup. Removed.

    -- Bigfile handling: now provided by snacks.bigfile (configured in
    -- lua/configs/snacks.lua). LunarVim/bigfile.nvim removed.
}
