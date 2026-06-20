-- telescope.nvim — performance-tuned defaults.
--
-- The big win here is loading telescope-fzf-native: a C sorter that's
-- 10-100x faster than the Lua default on large repos. The dependency was
-- declared in plugins/files.lua but never `load_extension`'d, so every
-- :Telescope call was using the slow Lua sorter.
--
-- Also tunes:
--   - find_command -> rg (faster + respects .gitignore by default)
--   - file_ignore_patterns to skip .git, node_modules, build artifacts
--   - smaller preview windows + lazy preview to keep keystrokes responsive
--   - cache_picker so repeated :Telescope find_files re-uses results
--   - "ivy" layout for finders (one-line input + below-line results)

local telescope = require("telescope")
local actions   = require("telescope.actions")

telescope.setup({
    defaults = {
        prompt_prefix = "  ",
        selection_caret = "  ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_strategy  = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width   = 0.55,
                results_width   = 0.45,
            },
            vertical   = { mirror = false },
            width      = 0.92,
            height     = 0.85,
            preview_cutoff = 100,
        },
        file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.lock$",
            "package%-lock%.json",
            "yarn%.lock",
            "%.svg$",
            "%.png$", "%.jpg$", "%.jpeg$", "%.webp$", "%.gif$", "%.ico$",
            "%.pdf$", "%.zip$", "%.tar%.gz$", "%.7z$",
            "__pycache__/", "%.pyc$",
            "%.o$", "%.obj$", "%.so$", "%.dylib$", "%.dll$",
            "target/",   -- rust
            "build/",
            "dist/",
            ".venv/", "venv/",
        },
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden",
            "--glob=!.git/", "--glob=!node_modules/",
        },
        cache_picker = {
            num_pickers = 5,                -- remember the last 5 picker results
            limit_entries = 1000,
        },
        preview = {
            filesize_limit = 1,             -- MB; skip preview for files larger
            timeout        = 250,           -- ms; skip preview if it takes longer
            treesitter     = true,
            msg_bg_fillchar = " ",
        },
        dynamic_preview_title = true,
        winblend = 0,
        history = {
            path = vim.fn.stdpath("state") .. "/telescope_history.sqlite3",
            limit = 200,
        },
        mappings = {
            i = {
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<esc>"] = actions.close,         -- single-esc closes
            },
        },
    },
    pickers = {
        find_files = {
            -- rg is 5-10x faster than find for cold-cache walks
            find_command = { "rg", "--files", "--hidden", "--glob=!.git/" },
            previewer    = false,           -- file finder doesn't need preview; speeds up startup
            theme        = "ivy",
            layout_config = { height = 0.4 },
        },
        oldfiles = { previewer = false, theme = "ivy", layout_config = { height = 0.4 } },
        buffers  = {
            previewer    = false,
            theme        = "ivy",
            sort_lastused = true,
            sort_mru      = true,
            layout_config = { height = 0.4 },
            mappings = { i = { ["<c-d>"] = actions.delete_buffer } },
        },
        live_grep = {
            -- ripgrep handles huge repos; just keep the args lean.
            additional_args = function() return { "--hidden", "--glob=!.git/" } end,
        },
        lsp_references         = { theme = "ivy", show_line = false },
        lsp_definitions        = { theme = "ivy", show_line = false },
        lsp_document_symbols   = { theme = "ivy" },
        lsp_workspace_symbols  = { theme = "ivy" },
        diagnostics            = { theme = "ivy" },
    },
    extensions = {
        fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,    -- replace the default sorter
            override_file_sorter    = true,    -- replace the file sorter
            case_mode               = "smart_case",
        },
    },
})

-- Load fzf-native (the perf win). pcall in case the C extension didn't
-- build (it needs `make` at install time); fall back to default sorter.
local ok, err = pcall(telescope.load_extension, "fzf")
if not ok then
    vim.notify("[telescope] fzf-native didn't load: " .. tostring(err) ..
        "\nRun `:Lazy build telescope-fzf-native.nvim` to rebuild.",
        vim.log.levels.WARN)
end
