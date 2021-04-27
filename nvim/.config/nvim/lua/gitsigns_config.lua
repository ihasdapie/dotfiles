
require('gitsigns').setup {
    current_line_blame = true,
    _refresh_staged_on_update = false,
    watch_index = {
        interval = 10000,
    },
    update_debounce = 1000,
    keymaps = {
        noremap=true,
    }
    -- use_decoration_api = false,
    -- debug_mode = true,

}
