-- snacks.nvim — folke's meta-plugin. Replaces alpha-nvim (dashboard),
-- LunarVim/bigfile.nvim (bigfile), and famiu/bufdelete.nvim (bufdelete).
--
-- Per "enable all the things": every module is opted in. Some overlap with
-- existing plugins (notifier vs noice/nvim-notify, picker vs telescope,
-- explorer vs neo-tree). Coexistence works — snacks doesn't forcibly take
-- over rhs of existing keymaps. Disable individual modules below if you
-- decide you don't want them.

require("snacks").setup({

    ----------------------------------------------------------------------
    -- Dashboard — port of the alpha layout that lived in configs/alpha.lua.
    -- snacks.dashboard preset = "doom"-style sections (header, keys, footer).
    ----------------------------------------------------------------------
    dashboard = {
        enabled = true,
        preset = {
            header = table.concat({
                "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
            }, "\n"),
            keys = {
                { icon = "\u{f0349} ", key = "f", desc = "Find File",    action = ":Telescope find_files" },     -- nf-md-magnify
                { icon = "\u{f0224} ", key = "n", desc = "New File",     action = ":ene | startinsert" },         -- nf-md-file_plus
                { icon = "\u{f02a8} ", key = "g", desc = "Find Text",    action = ":Telescope live_grep" },       -- nf-md-text_box_search
                { icon = "\u{f024c} ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },        -- nf-md-history
                { icon = "\u{f024b} ", key = "p", desc = "Project",      action = ":Telescope find_files" },      -- nf-md-folder_open
                { icon = "\u{f013} ",  key = "c", desc = "Config",       action = ":e ~/.config/nvim-fast-2/init.lua" }, -- nf-fa-cog
                { icon = "\u{f04b2} ", key = "L", desc = "Lazy",         action = ":Lazy" },                      -- nf-md-package_variant
                { icon = "\u{f487} ",  key = "M", desc = "Mason",        action = ":Mason" },                     -- nf-oct-tools
                { icon = "\u{f44a} ",  key = "h", desc = "Health",       action = ":checkhealth" },               -- nf-md-medical_bag
                { icon = "\u{f0a48} ", key = "q", desc = "Quit",         action = ":qa" },                        -- nf-md-exit_to_app
            },
        },
        sections = {
            { section = "header" },
            { section = "keys",    gap = 1, padding = 1 },
            { section = "startup" },  -- built-in: prints "X/Y plugins loaded in Zms"
        },
    },

    ----------------------------------------------------------------------
    -- File / buffer handling
    ----------------------------------------------------------------------
    bigfile     = { enabled = true, size = 2 * 1024 * 1024 },  -- 2 MB threshold
    quickfile   = { enabled = true },                          -- render before plugins on file open
    bufdelete   = { enabled = true },                          -- :lua Snacks.bufdelete()
    rename      = { enabled = true },                          -- LSP-aware rename on disk

    ----------------------------------------------------------------------
    -- UI / visuals. Several modules here parse treesitter / re-render on
    -- every cursor move and add real typing latency on big files. Pruned:
    --   - dim:   off — repaints out-of-scope code on CursorMoved (heavy).
    --   - scope: stays but kept for indent.scope only (no guides on its own).
    --   - animate: off — adds frame-throttled redraws to scroll/zen anims.
    -- Keep snacks.indent (guides) and statuscolumn — both are paint-light.
    ----------------------------------------------------------------------
    indent       = { enabled = true, animate = { enabled = false } }, -- guides yes, animation no
    scope        = { enabled = true },                          -- still needed for indent.scope highlight
    scroll       = { enabled = false },                         -- smooth scroll OFF
    statuscolumn = { enabled = true },
    dim          = { enabled = false },                         -- OFF — was repainting on every cursor move
    animate      = { enabled = false },                         -- OFF — frame-throttled draws hurt latency
    layout       = { enabled = true },
    win          = { enabled = true },

    ----------------------------------------------------------------------
    -- Notifications. Coexists with noice + nvim-notify; whichever sets
    -- vim.notify last wins. snacks.notifier is opinionated and pretty —
    -- if noice's view feels nicer, set notifier.enabled = false.
    ----------------------------------------------------------------------
    -- Notifier OFF: Brian wants traditional full-width cmdline messages, not
    -- top-right popup notifications. noice.messages is also disabled.
    notifier = { enabled = false },
    notify   = { enabled = false },

    ----------------------------------------------------------------------
    -- Pickers / file UI. Coexists with telescope + neo-tree — these are
    -- alternatives, not replacements (no global keymaps stolen).
    ----------------------------------------------------------------------
    picker   = { enabled = true },                              -- :lua Snacks.picker.<source>()
    explorer = { enabled = true },                              -- :lua Snacks.explorer()
    input    = { enabled = false },                             -- OFF: use native cmdline for input prompts
    image    = { enabled = true },                              -- inline image previews

    ----------------------------------------------------------------------
    -- Git
    ----------------------------------------------------------------------
    git       = { enabled = true },                             -- Snacks.git.* helpers
    gitbrowse = { enabled = true },                             -- :lua Snacks.gitbrowse()
    lazygit   = { enabled = true },                             -- :lua Snacks.lazygit()

    ----------------------------------------------------------------------
    -- Editor utility
    ----------------------------------------------------------------------
    words     = { enabled = true, debounce = 250 },             -- highlight word under cursor (debounced from 100ms to reduce re-paint while typing/moving)
    terminal  = { enabled = true },                             -- Snacks.terminal()
    scratch   = { enabled = true },                             -- :lua Snacks.scratch()
    toggle    = { enabled = true },                             -- Snacks.toggle.* helpers
    zen       = { enabled = true },                             -- :lua Snacks.zen()

    ----------------------------------------------------------------------
    -- Dev / instrumentation
    ----------------------------------------------------------------------
    debug     = { enabled = true },                             -- Snacks.debug.run()
    profiler  = { enabled = true },                             -- Snacks.profiler.*
    util      = { enabled = true },
})

----------------------------------------------------------------------------
-- Restore statusline / tabline once the dashboard buffer is left. Mirrors
-- the previous alpha behaviour (we hide them in plugins/ui.lua snacks.init
-- so they don't flash through the dashboard).
----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("User", {
    pattern  = "SnacksDashboardClosed",
    callback = function()
        vim.opt.laststatus  = 3
        vim.opt.showtabline = 2
        vim.opt.cmdheight   = 2  -- match init.lua; cmdheight=1 overflows on /notfound + E486 → hit-enter prompt
    end,
})
