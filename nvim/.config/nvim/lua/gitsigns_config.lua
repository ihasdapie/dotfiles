
require('gitsigns').setup {
    current_line_blame = true,
    _refresh_staged_on_update = false,
    watch_gitdir = {
        follow_files = true,
        interval = 10000,
    },
    update_debounce = 1000,
    on_attach = function(bufnr)
    end,
    debug_mode = true,
    --[[ current_line_blame_opts = {
        virt_text_pos = 'right_align',
    } ]]
    -- use_decoration_api = false,

}
