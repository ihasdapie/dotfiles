-- Now don't forget to initialize lualine




local lualine = require 'lualine'


local config = {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = "",
    section_separators = "",
    section_separators = { '', '' },
    component_separators = { '', '' },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}



lualine.setup(config)
