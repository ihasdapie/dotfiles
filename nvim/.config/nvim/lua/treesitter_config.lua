require'nvim-treesitter.configs'.setup {
    autotag = {
        enable = true,
        filetypes =  {'html', 'javascript', 'ttypescript', 'xml', 'markdown'}
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        custom_captures = {
            -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
            -- ["foo.bar"] = "Identifier",
        },
    },
    indent = {
        enable = false
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "tnn",
            node_incremental = "trn",
            scope_incremental = "trc",
            node_decremental = "trm",
        },
    },
    rainbow = {
        enable = true,
    },
    refactor = {
        highlight_definitions = {enable = true},
        highlight_current_scope = {enable = false},
        --[[ navigation = {
            enable=true,
            keymaps = {
                goto_definition = "tgd",
            }
        },
        smart_rename = {
            enable=true,
            keymaps = {
                smart_rename = "trn"
            } ]]
        -- }
    },
    --[[ textsubjects = {
        enable = true,
        -- prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
            [';'] = 'textsubjects-smart',
            ['.'] = 'textsubjects-container-outer',
            [','] = 'textsubjects-container-inner',
        },
    }, ]]
}
