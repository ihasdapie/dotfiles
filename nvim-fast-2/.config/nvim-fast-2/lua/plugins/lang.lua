-- Language support: treesitter, syntax plugins, format/lint helpers

return {
    -- Treesitter — pin to v0.10.0 (latest STABLE tag with the configs API).
    -- The main branch is alpha v1 with breaking changes. We can revisit when
    -- v1 reaches stable.
    {
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.10.0",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile", "VeryLazy" },
        config = function() require("configs.treesitter") end,
    },

    -- Symbol outline — REPLACES vista.vim
    {
        "stevearc/aerial.nvim",
        cmd = { "AerialToggle", "AerialNavToggle", "AerialOpen", "Vista" },
        keys = { "<leader>ss", "<leader>tv" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        config = function() require("configs.aerial") end,
    },

    -- LaTeX
    {
        "lervag/vimtex",
        ft = { "tex", "bib" },
        cmd = { "VimtexInverseSearch", "VimtexView", "VimtexCompile" },
    },

    -- Pandoc — only on explicit pandoc filetypes, NOT on plain markdown.
    -- vim-pandoc-syntax is a heavy vimscript syntax that pulls in 7 embedded
    -- language syntax files (see g:pandoc#syntax#codeblocks#embeds#langs in
    -- legacy.vim). Treesitter (markdown + markdown_inline) is the default
    -- highlighter for .md now; opt a buffer in with `:set ft=pandoc` if you
    -- want pandoc syntax for it.
    {
        "vim-pandoc/vim-pandoc",
        ft = { "pandoc", "pdc" },
        cmd = { "Pandoc" },
        dependencies = { "vim-pandoc/vim-pandoc-syntax" },
    },

    -- Niche language syntaxes
    { "ARM9/arm-syntax-vim", ft = { "asm", "arm" } },
    { "hylang/vim-hy", ft = "hy" },
    { "nathangrigg/vim-beancount", ft = "beancount" },
    { "liuchengxu/graphviz.vim", ft = "dot" },
    { "weirongxu/plantuml-previewer.vim", ft = "plantuml",
      dependencies = { "tyru/open-browser.vim" } },
    { "mechatroner/rainbow_csv", ft = "csv" },

    -- Org mode
    { "nvim-orgmode/orgmode", ft = "org" },

    -- Docstring generator
    {
        "danymat/neogen",
        cmd = "Neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function() require("neogen_config") end,
    },

    -- Math preview
    { "jbyuki/nabla.nvim", keys = { "<localleader>v" } },

    -- ASCII drawing
    { "jbyuki/venn.nvim", cmd = "VBox" },

    -- Snippet runner
    { "michaelb/sniprun", build = "bash install.sh", cmd = "SnipRun" },

    -- DB UI
    { "kristijanhusak/vim-dadbod-ui", cmd = { "DBUI", "DB" },
      dependencies = "tpope/vim-dadbod" },
    { "tpope/vim-dadbod", cmd = { "DBUI", "DB" } },

    -- Markdown image paste
    {
        "ferrine/md-img-paste.vim",
        ft = { "pandoc", "markdown", "latex", "tex" },
    },
}
