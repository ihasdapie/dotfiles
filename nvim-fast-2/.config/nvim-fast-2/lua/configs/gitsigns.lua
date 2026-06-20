-- gitsigns.nvim — nvim-fast-2 override of nvim-arm/lua/gitsigns_config.lua.
--
-- Why split: the nvim-arm copy enables linehl=true, numhl=true, and
-- current_line_blame=true. All three repaint on every text change. On
-- ~5k-line files the cumulative redraw pushed insert-mode latency into
-- the noticeable range. nvim-fast-2 keeps signs (cheap) but drops the
-- per-line highlights and blame virt_text — toggle them on demand with
-- :Gitsigns toggle_linehl / toggle_numhl / toggle_current_line_blame
-- when you actually want them.

require("gitsigns").setup({
    signs = {
        add          = { text = "┃" },
        change       = { text = "┃" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
    },
    signs_staged = {
        add          = { text = "┃" },
        change       = { text = "┃" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
    },
    signs_staged_enable     = true,
    signcolumn              = true,
    numhl                   = false,   -- was true; off for typing perf
    linehl                  = false,   -- was true; off for typing perf
    word_diff               = false,
    watch_gitdir            = { follow_files = true },
    auto_attach             = true,
    attach_to_untracked     = false,
    current_line_blame      = true,    -- Brian wants the inline blame; debounced via current_line_blame_opts.delay
    current_line_blame_opts = {
        virt_text         = true,
        virt_text_pos     = "eol",
        delay             = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus         = true,
    },
    current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
    sign_priority    = 6,
    update_debounce  = 500,
    status_formatter = nil,
    max_file_length  = 40000,
    preview_config   = {
        style    = "minimal",
        relative = "cursor",
        row      = 0,
        col      = 1,
    },
})
