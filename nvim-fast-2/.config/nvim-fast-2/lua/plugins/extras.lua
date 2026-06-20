-- Niche / utility plugins

return {
    -- Hydra
    {
        "nvimtools/hydra.nvim",
        event = "VeryLazy",
        config = function() require("hydra_config") end,
    },
    { "anuvyklack/keymap-layer.nvim", lazy = true },

    -- Floating terminal + bottom drawer — REPLACES vim-floaterm (vimscript)
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm",
                "FloatermToggle", "FloatermNew", "FloatermNext", "FloatermPrev", "FloatermKill",
                "DrawerToggle", "DrawerOpen", "DrawerClose", "DrawerKill" },
        keys = { "<leader>tt", "<leader>tD", "<leader>ot",
                 "<localleader>tt", "<localleader>tn",
                 "<localleader>tl", "<localleader>th",
                 "<localleader>tq", "<localleader>tc", "<localleader>td" },
        config = function() require("configs.toggleterm") end,
    },

    -- Distraction-free mode
    {
        "kdav5758/TrueZen.nvim",
        cmd = { "TZMinimalist", "TZAtaraxis" },
    },

    -- Minimap
    { "wfxr/minimap.vim", cmd = "MinimapToggle" },

    -- Window management
    { "sindrets/winshift.nvim", cmd = "WinShift" },
    { "szw/vim-maximizer", cmd = "MaximizerToggle" },
    -- bufdelete: now provided by snacks.bufdelete (configured in
    -- lua/configs/snacks.lua). legacy_aliases.lua exposes :Bdelete /
    -- :BWipeout user-commands that proxy to Snacks.bufdelete().
    { "mbbill/undotree", cmd = "UndotreeToggle" },

    -- Tabular align
    { "godlygeek/tabular", cmd = "Tabularize" },

    -- Sudo write
    { "lambdalisue/suda.vim", cmd = { "SudaRead", "SudaWrite" } },

    -- ANSI colors in buffers
    { "powerman/vim-plugin-AnsiEsc", cmd = "AnsiEsc" },

    -- Dispatch (async make/build)
    { "tpope/vim-dispatch", cmd = { "Make", "Dispatch", "Start", "Spawn",
                                    "Copen", "Focus" } },

    -- Diff utilities
    { "rickhowe/spotdiff.vim", cmd = "Spotdiff" },
    { "jmcantrell/vim-diffchanges", cmd = { "DiffChangesDiffToggle",
                                            "DiffChangesPatchToggle" } },

    -- Trouble (diagnostics list)
    { "folke/trouble.nvim", cmd = { "Trouble", "TroubleToggle", "TroubleClose" } },

    -- Grug-far (find/replace)
    { "MagicDuck/grug-far.nvim", cmd = "GrugFar",
      dependencies = "nvim-lua/plenary.nvim" },

    -- Open browser
    { "tyru/open-browser.vim",
      cmd = { "OpenBrowser", "OpenBrowserSearch", "OpenBrowserSmartSearch" } },

    -- Autocmd CursorHold fix (safe to keep, but actually unneeded on nvim 0.6+)
    -- { "antoinemadec/FixCursorHold.nvim" },  -- DISABLED: not needed on 0.11

    -- Bazel
    { "google/vim-maktaba", cmd = "Bazel" },
    { "bazelbuild/vim-bazel", cmd = "Bazel" },

    -- Leetcode (rare)
    {
        "ianding1/leetcode.vim",
        cmd = { "LeetCodeList", "LeetCodeReset", "LeetCodeSignIn",
                "LeetCodeSubmit", "LeetCodeTest" },
    },

    -- Tabby/dashboard helpers (snacks.nvim already declared in ui.lua)
    -- { "lewis6991/impatient.nvim" },  -- DISABLED: replaced by vim.loader

    -- Plenary (general utility) — most plugins depend on it
    { "nvim-lua/plenary.nvim", lazy = true },

    -- Startup-time profiler. dstein64/vim-startuptime is the modern
    -- replacement for tweekmonster/startuptime.vim — actively maintained,
    -- handles --startuptime + tabular UI. `:StartupTime` opens the report.
    -- Lazy on cmd so it adds zero cold-start cost.
    { "dstein64/vim-startuptime", cmd = "StartupTime",
      init = function()
          -- Default 10 startup runs is overkill; 5 gives stable medians.
          vim.g.startuptime_tries = 5
      end,
    },
}
