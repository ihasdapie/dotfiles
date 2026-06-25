-- toggleterm.nvim — REPLACES vim-floaterm with a Lua, neovim-native terminal.
-- Two surfaces:
--   * a stack of FLOATING terminals      (default size, curved border)
--   * a single bottom DRAWER terminal    (horizontal split anchored to the
--                                         bottom of the editor — IDE-style)
-- Provides :Floaterm* command aliases for muscle memory.

require("toggleterm").setup({
    size = function(term)
        if term.direction == "horizontal" then
            return math.max(12, math.floor(vim.o.lines * 0.30))
        end
        return 20
    end,
    open_mapping = nil,
    direction = "float",                 -- default direction for ad-hoc :ToggleTerm
    float_opts = { border = "curved", winblend = 0 },
    shell = vim.o.shell,
    persist_size = true,
    persist_mode = true,
    auto_scroll = true,
    insert_mappings = true,
    terminal_mappings = true,
})

local Terminal = require("toggleterm.terminal").Terminal

-- ---------------------------------------------------------------------------
-- Floats: indexed stack, created on demand.
local floats = {}

local function float_at(idx)
    if not floats[idx] then
        floats[idx] = Terminal:new({ direction = "float", count = idx })
    end
    return floats[idx]
end

local function current_or_first()
    if #floats == 0 then floats[1] = Terminal:new({ direction = "float", count = 1 }) end
    return floats[1]
end

-- ---------------------------------------------------------------------------
-- Drawer: a single bottom-anchored horizontal terminal. Reuses one slot so
-- toggling always brings the SAME shell back, IDE-style. count = 99 is just
-- a high number to keep it out of the float stack's count range.
local drawer
local function get_drawer()
    if not drawer then
        drawer = Terminal:new({
            direction = "horizontal",
            count = 99,
            -- Pin to the very bottom of the editor regardless of current
            -- window layout. Without this, toggleterm opens the split
            -- relative to the active window.
            on_open = function(t)
                vim.cmd("wincmd J")
                vim.api.nvim_win_set_height(t.window, math.max(12, math.floor(vim.o.lines * 0.30)))
                vim.cmd("startinsert")
            end,
        })
    end
    return drawer
end

-- ---------------------------------------------------------------------------
-- Floaterm-compat user commands (existing muscle memory).
vim.api.nvim_create_user_command("FloatermToggle", function() require("toggleterm").toggle() end, {})
vim.api.nvim_create_user_command("FloatermNew", function() float_at(#floats + 1):toggle() end, {})
vim.api.nvim_create_user_command("FloatermNext", function() current_or_first():toggle() end, {})
vim.api.nvim_create_user_command("FloatermPrev", function() current_or_first():toggle() end, {})
vim.api.nvim_create_user_command("FloatermKill", function()
    if #floats > 0 then
        floats[#floats]:shutdown()
        table.remove(floats)
    end
end, {})

-- Drawer commands.
vim.api.nvim_create_user_command("DrawerToggle", function() get_drawer():toggle() end, {})
vim.api.nvim_create_user_command("DrawerOpen",   function()
    local d = get_drawer()
    if not d:is_open() then d:toggle() end
end, {})
vim.api.nvim_create_user_command("DrawerClose",  function()
    if drawer and drawer:is_open() then drawer:toggle() end
end, {})
vim.api.nvim_create_user_command("DrawerKill",   function()
    if drawer then drawer:shutdown(); drawer = nil end
end, {})

-- Direct keymaps for the drawer (separate from <leader> entries in
-- which-key, so they work even before which-key has loaded).
vim.keymap.set({ "n", "t" }, "<leader>tD", "<cmd>DrawerToggle<cr>",
    { silent = true, desc = "Toggle bottom drawer terminal" })
