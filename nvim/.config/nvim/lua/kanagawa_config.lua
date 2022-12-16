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
    commentStyle = {italic = true},
    functionStyle = {italic = true},
    keywordStyle = {bold = true},
    statementStyle = {bold = true} ,
    -- typeStyle = "NONE",
    variablebuiltinStyle = {italic = true},
    specialReturn = true,       -- special highlight for the return keyword
    specialException = true,    -- special highlight for exception handling keywords 
    transparent = false,        -- do not set background color
    dimInactive = true,
    globalStatus = true,
    colors = {
        -- change background to ibm carbon
        sumiInk1 = '#161616',
        sumiInk0 = '#101010'
    },
    overrides = {
        --[[ GitSignsCurrentLineBlame = {
            fg = default_colors.winterYellow, bg = default_colors.sumiInk3,
        }, ]]
        CocMenuSel = {
            bg = default_colors.boatYellow1,
        },
    },
    theme = "default"
})

































