-- Git integration

return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        -- Was using nvim-arm/lua/gitsigns_config.lua, which enables
        -- linehl/numhl/current_line_blame — all repaint on every text
        -- change and were measurable typing-latency contributors.
        -- configs/gitsigns.lua is the nvim-fast-2 perf-tuned override.
        config = function() require("configs.gitsigns") end,
    },

    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git", "Gdiff", "Gdiffsplit", "Gvdiffsplit",
                "Gblame", "Glog", "Gllog", "Gstatus", "Gwrite", "Gread",
                "Gpush", "Gpull", "Gfetch", "Gmerge", "Grebase", "Gcommit",
                "GBrowse", "GMove", "GRename", "GDelete", "GRemove", "Gclog" },
    },

    {
        "ruifm/gitlinker.nvim",
        keys = {
            { "<leader>gy", mode = { "n", "v" } },
            { "<leader>gY", mode = { "n", "v" } },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function() require("gitlinker_config") end,
    },
}
