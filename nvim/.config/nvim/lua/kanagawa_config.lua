local default_colors = require('kanagawa.colors').setup()

vim.opt.fillchars:append({
    horiz = '━',
    horizup = '┻',
    horizdown = '┳',
    vert = '┃',
    vertleft = '┫',
    vertright = '┣',
    verthoriz = '╋',
})




require('kanagawa').setup({
    undercurl = true,           -- enable undercurls
    commentStyle = "italic",
    functionStyle = "italic",
    keywordStyle = "bold",
    statementStyle = "bold",
    typeStyle = "NONE",
    variablebuiltinStyle = "italic",
    specialReturn = true,       -- special highlight for the return keyword
    specialException = true,    -- special highlight for exception handling keywords 
    transparent = false,        -- do not set background color
    dimInactive = false,
    globalStatus = true,
    colors = {},
    overrides = {
        GitSignsCurrentLineBlame = {
            fg = default_colors.winterYellow, bg = default_colors.sumiInk3,
        },
    },
})

































