-- UI: colorscheme, statusline, tabline, dashboard, cmdline, notifications

return {
    -- Colorscheme — load before everything (priority 1000)
    {
        "metalelf0/kintsugi-nvim",
        priority = 1000,
        lazy = false,
        config = function()
            vim.cmd.colorscheme("kintsugi-flared")
        end,
    },

    -- Other colorschemes — only loaded when user runs :colorscheme <name>
    {
        "rebelot/kanagawa.nvim",
        lazy = true,
        config = function() pcall(require, "kanagawa_config") end,
    },
    { "nyoom-engineering/oxocarbon.nvim", lazy = true },
    { "gruvbox-community/gruvbox", lazy = true },
    { "ihasdapie/spaceducky", lazy = true },
    { "b4skyx/serenade", lazy = true },
    { "Luxed/ayu-vim", lazy = true },
    { "catppuccin/nvim", name = "catppuccin", lazy = true },
    { "Yagua/nebulous.nvim", lazy = true },
    { "theniceboy/nvim-deus", lazy = true },
    { "Mofiqul/dracula.nvim", lazy = true },
    { "Everblush/everblush.nvim", lazy = true },
    { "sainnhe/sonokai", lazy = true },

    -- Web devicons (used by lualine, neo-tree, telescope, etc.)
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Statusline — KEEPING galaxyline (user's custom 551-line config).
    -- DO NOT load on VimEnter — that paints the statusline behind the alpha
    -- dashboard and races with alpha's own draw, causing the visible flash
    -- + cursor-in-bottom-right symptom on cold launch. Defer to first file
    -- open instead; the dashboard suppresses the statusline anyway.
    {
        "glepnir/galaxyline.nvim",
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require("galaxyline_config") end,
    },

    -- Tabline — same reasoning as galaxyline.
    {
        "nanozuki/tabby.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require("tabby_config") end,
    },

    -- snacks.nvim — meta-plugin: dashboard, picker, explorer, indent,
    -- scroll, notifier, terminal, zen, words, scope, statuscolumn, etc.
    -- Replaces alpha-nvim (dashboard) and absorbs bigfile + bufdelete
    -- (specs in editor.lua and extras.lua are removed). All modules are
    -- enabled in lua/configs/snacks.lua per "enable all the things".
    --
    -- lazy = false + priority 999 (just under kanagawa) so the dashboard
    -- is ready at VimEnter. Hide statusline/tabline BEFORE the dashboard
    -- renders so galaxyline/tabby don't flash through.
    {
        "folke/snacks.nvim",
        priority = 999,
        lazy = false,
        init = function()
            if vim.fn.argc() == 0 then
                vim.opt.laststatus  = 0
                vim.opt.showtabline = 0
            end
        end,
        config = function() require("configs.snacks") end,
    },

    -- Cmdline + messages: using native vim cmdline (see shortmess/cmdheight
    -- in init.lua). noice.nvim was removed because it lazy-loaded on VeryLazy
    -- and its E486/return_prompt routes weren't live for the first `/`-search
    -- of the session, producing a "Press ENTER" prompt on no-match. Brian
    -- prefers the traditional full-width cmdline anyway (see snacks.lua).
}
