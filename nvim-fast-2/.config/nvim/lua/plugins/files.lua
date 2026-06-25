-- File browsing + finders

return {
    -- neo-tree (coc-explorer-style sidebar) — REPLACES oil.nvim/fern.vim
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        keys = {
            { "-",          "<cmd>Neotree reveal<cr>",            desc = "Reveal current file in tree" },
            { "<leader>op", "<cmd>Neotree toggle left<cr>",       desc = "Toggle project sidebar" },
            { "<leader>ob", "<cmd>Neotree toggle source=buffers left<cr>", desc = "Toggle buffers sidebar" },
            { "<leader>og", "<cmd>Neotree toggle source=git_status left<cr>", desc = "Toggle git sidebar" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "s1n7ax/nvim-window-picker",
        },
        config = function() require("configs.neo-tree") end,
    },

    -- Window picker — used by neo-tree's `e` action and exposed for ad-hoc use.
    -- Setup is invoked from configs/neo-tree.lua so we just load the plugin here.
    { "s1n7ax/nvim-window-picker", lazy = true },

    -- nnn (terminal file manager) — keep, only on :NnnPicker
    {
        "mcchrish/nnn.vim",
        cmd = { "NnnPicker", "NnnExplorer" },
    },

    -- fzf core
    { "junegunn/fzf", build = ":call fzf#install()", lazy = false },
    -- fzf.vim is loaded on VimEnter so the user's custom :Rg / :RG / :RgHidden
    -- commands (defined in legacy.vim) can resolve `fzf#vim#grep` autoload.
    -- Tiny plugin (~150 KB), worth the early load for the compat win.
    {
        "junegunn/fzf.vim",
        lazy = false,                -- user's :Rg in legacy.vim needs autoload
        dependencies = { "junegunn/fzf" },
        config = function()
            vim.api.nvim_create_user_command("FzfHistoryCmd", "History:", {})
            vim.api.nvim_create_user_command("FzfHistorySearch", "History/", {})
        end,
    },

    -- Telescope. Tuned in configs/telescope.lua: fzf-native sorter (10-100x
    -- faster than the default Lua sorter — was being shipped as a dep but
    -- never load_extension'd, so every :Telescope call paid the slow path),
    -- rg as find_command, ivy theme for file/buffer pickers, file_ignore
    -- patterns to skip node_modules / build dirs / binaries, cache_picker
    -- so re-opening :Telescope find_files in the same session is instant.
    {
        "nvim-telescope/telescope.nvim",
        cmd  = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function() require("configs.telescope") end,
    },

    -- zoxide for cd
    { "nanotee/zoxide.vim", cmd = { "Z", "Zi", "Lz", "Lzi", "Tz", "Tzi" } },
}
