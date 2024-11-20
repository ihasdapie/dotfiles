local filename = require('tabby.filename')
local util = require('tabby.util')
local hl_extract = require('tabby.module.highlight').extract

local hl_tabline = hl_extract('TabLine')
local hl_normal = hl_extract('Normal')
local hl_tabline_sel = hl_extract('TabLineSel')
local hl_tabline_fill = hl_extract('TabLineFill')




-- TODO: This palette doesn't work great with some themes
local palette = {
    accent = hl_tabline_sel.bg,     -- orange
    accent_sec = hl_tabline_sel.bg, -- fg4
    bg = hl_tabline.bg,             -- bg1
    bg_sec = hl_tabline_fill.bg,    -- bg2
    fg = hl_normal.fg,              -- fg2
}

-- define a default palette
local palette = {
    accent = "#FFCC66",
    accent_sec = "#D4BFFF",
    bg = "#1F2430",     -- bg1
    bg_sec = "#5C6773", -- bg2
    fg = "#CBCCC6",     -- fg2
}





local cwd = function()
    return ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
end
local tabname = function(tabid)
    return vim.api.nvim_tabpage_get_number(tabid)
end

local line = {
    hl = { fg = palette.fg, bg = palette.bg },
    layout = 'active_wins_at_tail',
    active_tab = {
        label = function(tabid)
            return {
                ' 󱗝 ' .. require('tabby.util').get_tab_name(tabid, tabname) .. ' ', hl = { fg = palette.bg, bg = palette.accent_sec, style = 'bold' },
            }
        end,
        left_sep = { '', hl = { fg = palette.accent_sec, bg = palette.bg } },
        right_sep = { '', hl = { fg = palette.accent_sec, bg = palette.bg } },
    },
    inactive_tab = {
        label = function(tabid)
            return {
                '  ' .. require('tabby.util').get_tab_name(tabid, tabname) .. ' ',
                hl = { fg = palette.fg, bg = palette.bg_sec, style = 'bold' },
            }
        end,
        left_sep = { '', hl = { fg = palette.bg_sec, bg = palette.bg } },
        right_sep = { '', hl = { fg = palette.bg_sec, bg = palette.bg } },
    },
    top_win = {
        label = function(winid)
            return {
                '  ' .. filename.relative(winid) .. ' ',
                hl = { fg = palette.bg, bg = palette.accent },
            }
        end,
        left_sep = { '', hl = { fg = palette.accent, bg = palette.bg } },
        right_sep = { '', hl = { fg = palette.accent, bg = palette.bg } },
    },
    win = {
        label = function(winid)
            return {
                '  ' .. filename.shorten(winid) .. ' ',
                hl = { fg = palette.fg, bg = palette.bg_sec },
            }
        end,
        left_sep = { '', hl = { fg = palette.bg_sec, bg = palette.bg } },
        right_sep = { '', hl = { fg = palette.bg_sec, bg = palette.bg } },
    },
    tail = {
        { '', hl = { fg = palette.accent, bg = palette.bg } },
        -- { '  ', hl = { fg = palette.bg, bg = palette.accent } },
    },
}
require('tabby').setup({ tabline = line })
