
require('gitsigns').setup {
    current_line_blame = true,
    _refresh_staged_on_update = false,
    watch_gitdir = {
        interval = 10000,
    },
    update_debounce = 1000,
    on_attach = function(bufnr)
    end
    --[[ current_line_blame_opts = {
        virt_text_pos = 'right_align',
    } ]]
    -- use_decoration_api = false,
    -- debug_mode = true,

}
