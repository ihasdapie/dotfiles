require("nebulous").setup {
  variant = "fullmoon",
  disable = {
    background = false,
    endOfBuffer = false,
  },
  italic = {
    comments   = true,
    keywords   = true,
    functions  = true,
    variables  = false,
  },
  custom_colors = { -- this table can hold any group of colors with their respective values
    CursorLineNr = { fg = "#E1CD6C", bg = "NONE", style = "NONE" },
    Comment = { fg = "#696f7a", bg = "NONE", style = "NONE" },
    -- it is possible to specify only the element to be changed
    --[[ TelescopePreviewBorder = { fg = "#A13413" },
    LspDiagnosticsDefaultError = { bg = "#E11313" },
    TSTagDelimiter = { style = "bold,italic" }, ]]
  }
}
