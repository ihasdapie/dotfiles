require('neorg').setup {
    -- Tell Neorg what modules to load
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.concealer"] = {}, -- Allows for use of icons
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    default = "~/neorg"
                }
            }
        }
    },

    hook = function ()
        local neorg_leader = "<localleader>n" -- You may also want to set this to <Leader>o for "organization"

        -- Require the user callbacks module, which allows us to tap into the core of Neorg
        local neorg_callbacks = require('neorg.callbacks')

        -- Listen for the enable_keybinds event, which signals a "ready" state meaning we can bind keys.
        -- This hook will be called several times, e.g. whenever the Neorg Mode changes or an event that
        -- needs to reevaluate all the bound keys is invoked
        neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)

            -- Map all the below keybinds only when the "norg" mode is active
            keybinds.map_event_to_mode("norg", {
                    n = { -- Bind keys in normal mode
                        -- Keys for managing TODO items and setting their states
                        { neorg_leader .. "td", "core.norg.qol.todo_items.todo.task_done" },
                        { neorg_leader .. "tu", "core.norg.qol.todo_items.todo.task_undone" },
                        { neorg_leader .. "tp", "core.norg.qol.todo_items.todo.task_pending" },
                        { neorg_leader .. "n" , "core.norg.qol.todo_items.todo.task_cycle" }

                    },
                }, { silent = true, noremap = true })

            end)




end
}


local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}



