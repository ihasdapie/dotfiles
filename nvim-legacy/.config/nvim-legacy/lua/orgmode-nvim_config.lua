local org_leader = "<localleader>o"

require('orgmode').setup_ts_grammar()


require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}



require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
        org_agenda_files = {'~/org/**/*', '~/org/*'},
        org_default_notes_file = '~/org/notes.org',
        org_todo_keywords = {'TODO', 'WAITING', '|', 'DONE', 'DELEGATED'},
        org_todo_keyword_faces = {
            WAITING = ':foreground blue :weight bold',
            DELEGATED = ':background #FFFFFF :slant italic :underline on',
        },
        mappings = {
            disable_all = false,
            global = {
                org_agenda = org_leader .. 'a',
                org_capture = org_leader .. 'c',
            },
            agenda = {
                org_agenda_later = 'f',
                org_agenda_earlier = 'b',
                org_agenda_goto_today = '.',
                org_agenda_day_view = 'vd',
                org_agenda_week_view = 'vw',
                org_agenda_month_view = 'vm',
                org_agenda_year_view = 'vy',
                org_agenda_quit = 'q',
                org_agenda_switch_to = '<CR>',
                org_agenda_goto = { '<TAB>' },
                org_agenda_goto_date = 'J',
                org_agenda_redo = 'r',
                org_agenda_todo = 't',
                org_agenda_show_help = '?',
            },
            capture = {
                org_capture_finalize = '<C-c>',
                org_capture_refile = org_leader .. 'r',
                org_capture_kill = org_leader .. 'k',
                org_capture_show_help = '?',
            },
            org = {
                org_refile = org_leader .. 'r',
                org_timestamp_up = '<C-a>',
                org_timestamp_down = '<C-x>',
                org_change_date = 'cid',
                org_todo = 'cit',
                org_todo_prev = 'ciT',
                org_toggle_checkbox = '<C-Space>',
                org_open_at_point = org_leader .. 'o',
                org_cycle = '<TAB>',
                org_global_cycle = '<S-TAB>',
                org_archive_subtree = org_leader .. '$',
                org_set_tags_command = org_leader .. 't',
                org_toggle_archive_tag = org_leader .. 'A',
                org_do_promote = '<<',
                org_do_demote = '>>',
                org_promote_subtree = '<s',
                org_demote_subtree = '>s',
                org_meta_return = '<localleader><CR>', -- Add headling, item or row
                org_insert_heading_respect_content = org_leader .. 'ih', -- Add new headling after current heading block with same level
                org_insert_todo_heading = org_leader .. 'iT', -- Add new todo headling right after current heading with same level
                org_insert_todo_heading_respect_content = org_leader .. 'it', -- Add new todo headling after current heading block on same level
                org_move_subtree_up = org_leader .. 'K',
                org_move_subtree_down = org_leader .. 'J',
                org_export = org_leader .. 'e',
                org_next_visible_heading = '}',
                org_previous_visible_heading = '{',
                org_forward_heading_same_level = ']]',
                org_backward_heading_same_level = '[[',
                outline_up_heading = 'g{',
                org_show_help = '?',
                },
            },
        })


-- The below which-key mappings are duplicated from above.
-- We only want to load it for `org` buffers
vim.cmd(([[
        autocmd FileType org lua whichkey_org()
    ]]))

_G.whichkey_org = function()
    local wk = require("which-key")
    local buf = vim.api.nvim_get_current_buf() -- make the mappings buffer-specific

    wk.register( {
        -- buffer = vim.api.nvim_get_current_buf(),
        ['<C-c>'] = "org capture finalize",
        cid = "org change date",
        cit = "org todo",
        ciT = "org todo prev",
        ['<c-space>'] = "org toggle checkbox",
        ['<TAB>'] = "org cycle",
        ['<S-TAB>'] = "org global cycle",
        ['<<'] = "org do promote",
        ['>>'] = "org do demote",
        ['<s'] = "org promote subtree",
        ['>s'] = "org demote subtree",
        ['<localleader><CR>'] = "org meta return", -- Add headling, item or ro = "org meta return",
        ['}'] = "org next visible heading",
        ['{'] = "org previous visible heading",
        [']]'] = "org forward heading same level",
        ['[['] = "org backward heading same level",
        ['g{'] = "outline up heading",
        ['?'] = "org show help",


        ["<localleader>"] = {
            o = {
                name = "+org",
                r = "org capture refile",
                -- r = "org refile",
                k = "org capture kill",
                ["?"] = "org capture show help",
                ['<C-a>'] = "org increment timestamp",
                ['<C-x>'] = "org decrement timestamp ",
                ih= "org insert heading respect content",
                iT= "org insert todo heading",
                it= "org insert todo heading respect content",
                K = "org move subtree up",
                J = "org move subtree down",
                e = "org export",
                ['$'] = "org archive subtree",
                t = "org set tags command",
                A = "org toggle archive tag",
                o = "org open at point",

            c = {
                name = "+capture"
            },

            a = {
                name = "+agenda",
                f = 'org agenda later',
                b = 'org agenda earlier',
                ["."] = 'org agenda goto today',
                vd = 'org agenda day view',
                vw = 'org agenda week view',
                vm = 'org agenda month view',
                vy = 'org agenda year view',
                q = 'org agenda quit',
                ["<CR>"] = 'org agenda switch to',
                ["<TAB>"] = 'org agenda goto',
                J = 'org agenda goto date',
                r = 'org agenda redo',
                t = 'org agenda todo',
                ["?"] = 'org agenda show help'
            } } } }

            )
end





















