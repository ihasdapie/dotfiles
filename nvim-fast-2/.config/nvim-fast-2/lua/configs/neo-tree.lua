-- neo-tree.nvim — coc-explorer-style sidebar with window-picker open.
-- REPLACES oil.nvim (which is buffer-style, not a sidebar).

-- 0. Kanagawa's dimInactive=true (in ~/.config/nvim-arm/lua/kanagawa_config.lua)
-- shadows every unfocused window via the NormalNC highlight group. That
-- makes the neo-tree sidebar look "shadowed" the moment focus leaves it.
-- Override per-window: map NormalNC -> Normal in any neo-tree buffer so the
-- sidebar always renders with the active background. Other splits still get
-- the global dim. Same trick for the source-selector winbar tabs.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "neo-tree",
    callback = function()
        vim.wo.winhighlight = table.concat({
            "Normal:Normal",
            "NormalNC:Normal",
            "EndOfBuffer:Normal",
            "SignColumn:Normal",
            "CursorLine:CursorLine",
        }, ",")
    end,
})

-- 1. Window picker — used by neo-tree's `e` action to ask "which window?"
require("window-picker").setup({
    hint = "floating-big-letter",
    selection_chars = "FJDKSLA;CMRUEIWOQP",
    filter_rules = {
        include_current_win = false,
        autoselect_one      = true,
        bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify", "noice", "snacks_dashboard", "alpha" },
            buftype  = { "terminal", "quickfix", "nofile", "prompt" },
        },
    },
})

-- 2. Neo-tree
require("neo-tree").setup({
    close_if_last_window      = true,
    enable_diagnostics        = true,
    enable_git_status         = true,
    sources                   = { "filesystem", "buffers", "git_status" },
    source_selector = {
        winbar           = true,
        statusline       = false,
        sources = {
            { source = "filesystem", display_name = " 󰉓 Files " },
            { source = "buffers",    display_name = " 󰈚 Bufs  " },
            { source = "git_status", display_name = " 󰊢 Git   " },
        },
    },
    default_component_configs = {
        indent       = {
            with_markers   = true,
            with_expanders = true,
            indent_marker  = "│",
            last_indent_marker = "└",
            expander_collapsed = "",
            expander_expanded  = "",
        },
        icon         = {
            folder_closed   = "",
            folder_open     = "",
            folder_empty    = "",
            folder_empty_open = "",
            default         = "",
        },
        modified     = { symbol = " ", highlight = "NeoTreeModified" },
        name         = { trailing_slash = false, use_git_status_colors = true, highlight = "NeoTreeFileName" },
        git_status   = {
            symbols = {
                -- nerd-font glyphs (was ASCII +/~/✖/?/◌/U/S/!)
                added     = "",
                modified  = "",
                deleted   = "",
                renamed   = "",
                untracked = "",
                ignored   = "",
                unstaged  = "󰄱",
                staged    = "",
                conflict  = "",
            },
            align = "right",
        },
    },
    window = {
        position = "left",
        width    = 32,
        mappings = {
            -- Open actions — user-requested layout
            ["<cr>"] = "open",
            ["o"]    = "open",
            ["e"]    = "open_with_window_picker",   -- pick window, edit there
            ["v"]    = "open_vsplit",                -- new vertical split
            ["s"]    = "open_split",                 -- new horizontal split
            ["t"]    = "open_tabnew",
            ["E"]    = "vsplit_with_window_picker",  -- vsplit at picked window
            ["S"]    = "split_with_window_picker",   -- split at picked window

            -- Navigation
            ["P"]    = { "toggle_preview", config = { use_float = true } },
            ["l"]    = "open",
            ["h"]    = "close_node",
            ["<bs>"] = "navigate_up",
            ["."]    = "set_root",
            -- NOTE: "/", "f", "<c-x>", "[g", "]g", "H" are filesystem-source
            -- only (the buffers/git_status sources don't implement them). They
            -- live under filesystem.window.mappings below so vim's default `/`
            -- search still works in the Bufs/Git tabs.

            -- File ops
            ["a"]    = { "add", config = { show_path = "relative" } },
            ["A"]    = "add_directory",
            ["d"]    = "delete",
            ["r"]    = "rename",
            ["y"]    = "copy_to_clipboard",
            ["x"]    = "cut_to_clipboard",
            ["p"]    = "paste_from_clipboard",
            ["c"]    = "copy",
            ["m"]    = "move",
            ["q"]    = "close_window",
            ["R"]    = "refresh",
            ["?"]    = "show_help",
            ["<"]    = "prev_source",
            [">"]    = "next_source",
        },
    },
    filesystem = {
        follow_current_file       = { enabled = true, leave_dirs_open = false },
        group_empty_dirs          = false,
        hijack_netrw_behavior     = "open_default",
        use_libuv_file_watcher    = true,
        filtered_items = {
            visible        = false,
            hide_dotfiles  = false,
            hide_gitignored = false,
            hide_by_name   = { ".DS_Store", "thumbs.db" },
            never_show     = { ".git" },
        },
        window = {
            mappings = {
                -- filesystem-source-only commands (fuzzy_finder, filter_on_submit,
                -- toggle_hidden, [g/]g for git-modified jumps). Putting them
                -- here keeps `/` doing vim search in the Bufs/Git tabs.
                ["/"]     = "fuzzy_finder",
                ["f"]     = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["H"]     = "toggle_hidden",
                ["[g"]    = "prev_git_modified",
                ["]g"]    = "next_git_modified",
            },
            fuzzy_finder_mappings = {
                ["<down>"] = "move_cursor_down",
                ["<up>"]   = "move_cursor_up",
                ["<C-n>"]  = "move_cursor_down",
                ["<C-p>"]  = "move_cursor_up",
                ["<esc>"]  = "close",
            },
        },
    },
    buffers = {
        -- show_unloaded=true and group_empty_dirs=true were what made
        -- switching to the Bufs tab feel slow — neo-tree was reading every
        -- never-opened buffer's metadata + re-tree-ing dir grouping. Off
        -- gives effectively instant tab switch.
        follow_current_file = { enabled = false },
        group_empty_dirs    = false,
        show_unloaded       = false,
    },
    git_status = {
        window = { mappings = { ["A"] = "git_add_all", ["gu"] = "git_unstage_file", ["ga"] = "git_add_file", ["gr"] = "git_revert_file", ["gc"] = "git_commit", ["gp"] = "git_push" } },
    },
    -- coc-explorer keeps the sidebar open after opening a file; mirror that.
    -- (No file_opened auto-close handler.)
})
