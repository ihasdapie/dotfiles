-- nvim-colorizer.lua — REPLACES chrisbra/Colorizer (vimscript, slow)

require("colorizer").setup({
    filetypes = { "*" },
    user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = false,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = false },
        virtualtext = "■",
        always_update = false,
    },
})
