-- legacy_aliases.lua — define user-facing commands that the user's existing
-- which-key bindings reference, but that are no longer provided in
-- nvim-fast-2 (because we removed/replaced the underlying plugin).
--
-- We define the commands as thin wrappers so the muscle memory keeps
-- working; the underlying mechanism is the modern Lua replacement.

-- Pull in the global NI_* helpers from nvim-arm/lua/functions.lua. Reachable
-- via the package.path prepend in init.lua step 3b. Defines:
--   NI_cycle_number, NI_cycle_conceallevel, NI_cycle_prose, NI_fzf_resize_window
-- which are referenced by which-key_config.lua (<leader>tn, <leader>tc,
-- <leader>tp). nvim-arm pulled these in via plugins.lua → require('functions');
-- nvim-fast-2 doesn't load plugins.lua, so we have to require it ourselves or
-- the bindings fail with "attempt to call a nil value (global 'NI_cycle_*')".
pcall(require, "functions")

local function cmd(name, target, opts)
    opts = opts or {}
    opts.desc = opts.desc or ("[nvim-fast-2 alias] " .. target)
    vim.api.nvim_create_user_command(name, function(args)
        local rhs = target
        if type(target) == "function" then
            return target(args)
        end
        if args.args and args.args ~= "" then
            rhs = rhs .. " " .. args.args
        end
        vim.cmd(rhs)
    end, { nargs = "*", bang = true, desc = opts.desc })
end

-- vim-plug → lazy.nvim
cmd("PlugInstall", "Lazy install")
cmd("PlugClean",   "Lazy clean")
cmd("PlugUpdate",  "Lazy update")
cmd("PlugStatus",  "Lazy")
cmd("PlugUpgrade", "Lazy")

-- nvim-reload → built-in :source $MYVIMRC
cmd("Reload",  "source $MYVIMRC")
cmd("Restart", "source $MYVIMRC")

-- which-key typo (user wrote :Whichkey, real cmd is :WhichKey)
cmd("Whichkey", "WhichKey")

-- coc.nvim → native LSP / telescope / neo-tree
cmd("CocRestart", "LspRestart")
cmd("CocRebuild", "Mason")
cmd("CocConfig",  "edit ~/.config/nvim-arm/coc-settings.json")
-- :CocSearch <pattern> -> live_grep (interactive) when no arg, grep_string when arg given
vim.api.nvim_create_user_command("CocSearch", function(args)
    local ok, builtin = pcall(require, "telescope.builtin")
    if not ok then
        vim.notify("[nvim-fast-2] telescope not loaded", vim.log.levels.WARN)
        return
    end
    if args.args and args.args ~= "" then
        builtin.grep_string({ search = args.args })
    else
        builtin.live_grep()
    end
end, { nargs = "*", desc = "[nvim-fast-2] CocSearch -> Telescope live_grep" })

-- :CocList <kind> [-A] [--normal] <args>
-- Map to the closest telescope/native equivalents.
vim.api.nvim_create_user_command("CocList", function(args)
    local arg_str = args.args or ""
    -- Strip flags like -A, --normal etc.
    local kind = arg_str:gsub("%-%-?%S+%s*", ""):gsub("^%s+", ""):gsub("%s+$", "")
    local map = {
        symbols       = "Telescope lsp_workspace_symbols",
        outline       = "Telescope lsp_document_symbols",
        diagnostics   = "Telescope diagnostics",
        ["yank"]      = "YankyRingHistory",
        commands      = "Telescope commands",
        files         = "Telescope find_files",
        buffers       = "Telescope buffers",
        marks         = "Telescope marks",
    }
    local target = map[kind] or "Telescope"
    vim.cmd(target)
end, { nargs = "*", desc = "[nvim-fast-2] CocList -> Telescope/Yanky" })

-- :CocCommand <subcmd>
vim.api.nvim_create_user_command("CocCommand", function(args)
    local sub = args.args or ""
    local map = {
        ["explorer"]                = "Neotree toggle left",
        ["explorer --reveal"]       = "Neotree reveal left",
        ["go.test.toggle"]          = function() vim.notify("[nvim-fast-2] go.test.toggle: use :GoTest after installing go.nvim, or :Make test", vim.log.levels.WARN) end,
        ["snippets.editSnippets"]   = "LuaSnipEdit",
    }
    -- prefix match
    for k, v in pairs(map) do
        if sub:match("^" .. vim.pesc(k)) then
            if type(v) == "function" then return v() end
            return vim.cmd(v)
        end
    end
    vim.notify("[nvim-fast-2] CocCommand " .. sub .. " has no alias", vim.log.levels.WARN)
end, { nargs = "*", desc = "[nvim-fast-2] CocCommand -> native equivalent" })

-- coc-yank list → yanky history
cmd("CocYank", "YankyRingHistory")

-- bufdelete: famiu/bufdelete.nvim removed; route :Bdelete / :BWipeout to
-- snacks.bufdelete. Same UX (preserves window layout) without the extra
-- plugin. <leader>bd in nvim-arm/which-key_config.lua still calls :Bdelete.
vim.api.nvim_create_user_command("Bdelete", function(args)
    local ok, snacks = pcall(require, "snacks")
    if ok then snacks.bufdelete({ force = args.bang }) else vim.cmd((args.bang and "bdelete!" or "bdelete")) end
end, { bang = true, desc = "[nvim-fast-2] snacks.bufdelete shim" })
vim.api.nvim_create_user_command("BWipeout", function(args)
    local ok, snacks = pcall(require, "snacks")
    if ok then snacks.bufdelete({ wipe = true, force = args.bang }) else vim.cmd((args.bang and "bwipeout!" or "bwipeout")) end
end, { bang = true, desc = "[nvim-fast-2] snacks.bufdelete (wipe) shim" })

-- coc-explorer reveal → :Neotree reveal
-- (handled in CocCommand above)

-- fzf-project (commented out in nvim-fast-2) → telescope
cmd("FzfSwitchProject",      "Telescope find_files")
cmd("FzfChooseProjectFile",  "Telescope find_files")

-- DashboardNewFile (dashboard-nvim → snacks.dashboard, no equivalent)
vim.api.nvim_create_user_command("DashboardNewFile", function()
    vim.cmd("enew")
    vim.cmd("startinsert")
end, { desc = "[nvim-fast-2] new empty buffer" })

-- indent-blankline v3 renamed the toggle command
cmd("IndentBlanklineToggle", "IBLToggle")

-- nvim-treesitter v0.9+ replaced TSBufToggle/TSContextToggle with module-system
-- They might or might not be available depending on the v.  Provide soft fallbacks.
vim.api.nvim_create_user_command("TSBufToggle", function(args)
    local module = args.args or "highlight"
    local ok, ts = pcall(require, "nvim-treesitter.configs")
    if not ok then
        vim.notify("[nvim-fast-2] nvim-treesitter not loaded yet", vim.log.levels.WARN)
        return
    end
    -- Best-effort: the v1 API uses :TSToggle <module>
    pcall(vim.cmd, "TSToggle " .. module)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TSContextToggle", function()
    if pcall(require, "treesitter-context") then
        vim.cmd("TSContextToggle")
    else
        vim.notify("[nvim-fast-2] treesitter-context not installed; add to plugins/lang.lua", vim.log.levels.WARN)
    end
end, {})

-- Pickachu (DougBeney/pickachu) was a Tk-based picker — comment out in nvim-fast-2.
-- Provide a no-op so keymaps don't error.
vim.api.nvim_create_user_command("Pickachu", function(args)
    vim.notify("[nvim-fast-2] Pickachu disabled. Use :Telescope " .. (args.args or "") , vim.log.levels.INFO)
end, { nargs = "*" })
cmd("Pick", "Pickachu")

-- vim-go commands: vim-go is heavy and not in nvim-fast-2 spec.
-- Map to gopls equivalents via native LSP code-actions.
local go_actions = {
    GoFillStruct = "Go: Fill Struct (use <leader>ca for code actions)",
    GoCallers    = "Go: Callers (use vim.lsp.buf.references)",
    GoTest       = "go test ./...",
}
for go_cmd, hint in pairs(go_actions) do
    vim.api.nvim_create_user_command(go_cmd, function()
        vim.notify("[nvim-fast-2] " .. go_cmd .. " unavailable. " .. hint, vim.log.levels.INFO)
    end, {})
end

-- LuaSnip-edit user snippets file (replaces :CocCommand snippets.editSnippets)
vim.api.nvim_create_user_command("LuaSnipEdit", function()
    require("luasnip.loaders").edit_snippet_files()
end, {})

-- Open coc-settings.json so user can still access it
vim.api.nvim_create_user_command("CocSettings", "edit ~/.config/nvim-arm/coc-settings.json", {})

-- Useful: surface which-key on demand even if its lazy load hasn't fired
cmd("WhichKey", "WhichKey", { desc = "Show which-key" })
