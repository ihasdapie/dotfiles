-- require'nvim-treesitter.config'.setup {
--     autotag = {
--         enable = true,
--         filetypes =  {'html', 'javascript', 'ttypescript', 'xml', 'markdown'}
--     },
--     highlight = {
--         enable = true,
--         additional_vim_regex_highlighting = false,
--         custom_captures = {
--             -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
--             -- ["foo.bar"] = "Identifier",
--         },
--     },
--     indent = {
--         enable = false
--     },
--     incremental_selection = {
--         enable = true,
--         keymaps = {
--             init_selection = "tnn",
--             node_incremental = "trn",
--             scope_incremental = "trc",
--             node_decremental = "trm",
--         },
--     },
--     rainbow = {
--         enable = true,
--     },
--     refactor = {
--         highlight_definitions = {enable = true},
--         highlight_current_scope = {enable = false},
--         --[[ navigation = {
--             enable=true,
--             keymaps = {
--                 goto_definition = "tgd",
--             }
--         },
--         smart_rename = {
--             enable=true,
--             keymaps = {
--                 smart_rename = "trn"
--             } ]]
--         -- }
--     },
--     --[[ textsubjects = {
--         enable = true,
--         -- prev_selection = ',', -- (Optional) keymap to select the previous selection
--         keymaps = {
--             [';'] = 'textsubjects-smart',
--             ['.'] = 'textsubjects-container-outer',
--             [','] = 'textsubjects-container-inner',
--         },
--     }, ]]
-- }

require('treesitter-modules').setup({
    -- list of parser names, or 'all', that must be installed
    ensure_installed = {},
    -- list of parser names, or 'all', to ignore installing
    ignore_install = {},
    -- install parsers in ensure_installed synchronously
    sync_install = false,
    -- automatically install missing parsers when entering buffer
    auto_install = false,
    fold = {
        enable = true,
    },
    highlight = {
        enable = true,
        -- setting this to true will run `:h syntax` and tree-sitter at the same time
        -- set this to `true` if you depend on 'syntax' being enabled
        -- using this option may slow down your editor, and duplicate highlights
        -- instead of `true` it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        -- set value to `false` to disable individual mapping
        -- node_decremental captures both node_incremental and scope_incremental
        keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
        },
    },
    indent = {
        enable = true,
    },
})
