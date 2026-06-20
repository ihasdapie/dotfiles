-- marks.nvim — REPLACES kshenoy/vim-signature

require("marks").setup({
    default_mappings = true,
    builtin_marks = { ".", "<", ">", "^" },
    cyclic = true,
    force_write_shada = false,
    refresh_interval = 250,
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    excluded_filetypes = { "dashboard", "snacks_dashboard", "help", "qf", "neo-tree",
                           "neo-tree-popup", "trouble", "lazy", "noice", "TelescopePrompt" },
    bookmark_0 = { sign = "⚑", virt_text = "" },
})
