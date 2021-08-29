
local gl = require('galaxyline')
local utils = require('utils.galaxyline_utils')
-- local config = require('utils.example_config')

local gls = gl.section
local extension = require('galaxyline.provider_extensions')

gl.short_line_list = {
    'LuaTree',
    'vista',
    'dbui',
    'startify',
    'term',
    'nerdtree',
    'fugitive',
    'fugitiveblame',
    'plug',
}

VistaPlugin = extension.vista_nearest

local colors = {
    bg = '#282c34',
    line_bg = '#353644',
    fg = '#8FBCBB', 
    fg_green = '#65a380',
    yellow = '#fabd2f',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#afd700',
    orange = '#FF8800',
    purple = '#5d4d7a',
    magenta = '#c678dd',
    blue = '#51afef';
    red = '#ec5f67'
}


local function format_lsp_status(status)
    local shorter_stat = ''
    for match in string.gmatch(status, "[^%s]+")  do
        local err_warn = string.find(match, "^[WE]%d+", 0) -- check what this regex does
        if not err_warn then
            shorter_stat = shorter_stat .. ' ' .. match
        end
    end
    return shorter_stat
end

local function get_coc_lsp()
  local status = vim.fn['coc#status']()
  if not status or status == '' then
      return ''
  end
  -- return lsp_status(status)
  return format_lsp_status(status)
end

local function get_venom()
  local virtualenv = vim.fn['venom#statusline']()
  return virtualenv
end


function get_diagnostic_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_lsp()
    end
  return ''
end

local function get_current_func()
  local cur_func = vim.b.coc_current_function
  if not cur_func or cur_func == '' then
    return nil
  end
  return '  ' .. cur_func
end


function get_function_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_current_func()
    end
  return ''
end


local function trailing_whitespace()
    local trail = vim.fn.search("\\s$", "nw")
    if trail ~= 0 then
        return ' '
    else
        return nil
    end
end

CocStatus = get_diagnostic_info
CocFunc = get_current_func
TrailingWhiteSpace = trailing_whitespace


function has_file_type()
    local f_type = vim.bo.filetype
    if not f_type or f_type == '' then
        return false
    end
    return true
end

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

gls.left[1] = {
  FirstElement = {
    provider = function() return ' ' end,
    highlight = {colors.blue,colors.line_bg}
  }, }


gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local alias = {
          n = 'NORMAL',
          i = 'INSERT',
          c= 'COMMAND',
          V= 'VISUAL',
          [''] = 'VISUAL',
          v ='VISUAL',
          ['^V'] = "VISUAL-BLOCK",
          c  = 'COMMAND-LINE',
          ['r?'] = ':CONFIRM',
          rm = '--MORE',
          R  = 'REPLACE',
          Rv = 'VIRTUAL',
          s  = 'SELECT',
          S  = 'SELECT',
          ['r']  = 'HIT-ENTER',
          [''] = 'SELECT',
          t  = 'TERMINAL',
          ['!']  = 'SHELL',
      }
      local mode_color = {
          n = colors.green,
          i = colors.blue,v=colors.magenta,[''] = colors.blue,V=colors.blue,
          c = colors.red,no = colors.magenta,s = colors.orange,S=colors.orange,
          [''] = colors.orange,ic = colors.yellow,R = colors.purple,Rv = colors.purple,
          cv = colors.red,ce=colors.red, r = colors.cyan,rm = colors.cyan, ['r?'] = colors.cyan,
          ['!']  = colors.green,t = colors.green,
          c  = colors.purple,
          ['r?'] = colors.red,
          ['r']  = colors.red,
          rm = colors.red,
          R  = colors.yellow,
          Rv = colors.magenta,
      }
      local vim_mode = vim.fn.mode()
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim_mode])
      -- return alias[vim_mode] .. '   '
      return alias[vim_mode] .. ' '
      -- return alias[vim_mode] .. '   '
    end,
    highlight = {colors.red,colors.line_bg,'bold'},
  }, }

gls.left[3] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.line_bg},
  },
}

gls.left[4] = {
  FileName = {
    provider = {'FileName','FileSize'},
    condition = buffer_not_empty,
    highlight = {colors.fg,colors.line_bg,'bold'}
  }
}

gls.left[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    highlight = {colors.orange,colors.line_bg},
  }
}
gls.left[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    highlight = {'#8FBCBB',colors.line_bg,'bold'},
  }
}

local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

gls.left[7] = {
DiffAdd = {
  provider = 'DiffAdd',
  condition = checkwidth,
  icon = '   ',
  highlight = {colors.green,colors.line_bg},
}
}
gls.left[8] = {
DiffModified = {
  provider = 'DiffModified',
  condition = checkwidth,
  icon = '  ',
  highlight = {colors.orange,colors.line_bg},
}
}
gls.left[9] = {
DiffRemove = {
  provider = 'DiffRemove',
  condition = checkwidth,
  icon = '  ',
  highlight = {colors.red,colors.line_bg},
}
}
gls.left[10] = {
LeftEnd = {
  provider = function() return '' end,
  separator = '',
  separator_highlight = {colors.bg,colors.line_bg},
  highlight = {colors.line_bg,colors.line_bg}
}
}

--[[ gls.left[11] = {
  TrailingWhiteSpace = {
   provider = TrailingWhiteSpace,
   icon = '  ',
   highlight = {colors.yellow,colors.bg},
  }
} ]]

gls.left[12] = {
DiagnosticError = {
  provider = 'DiagnosticError',
  icon = '  ',
  highlight = {colors.red,colors.bg}
}
}
gls.left[13] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.bg, colors.bg}
} }

gls.left[14] = {
DiagnosticWarn = {
  provider = 'DiagnosticWarn',
  icon = '  ',
  highlight = {colors.yellow,colors.bg},
} }

gls.left[15] = {
  CocStatus = {
   provider = CocStatus,
   highlight = {colors.green,colors.bg},
   icon = ' 🗱 '
  }
}

gls.left[16] = {
CocFunc = {
  provider = CocFunc,
  -- icon = '  λ ',
  highlight = {colors.fg_green, colors.bg},
}
}


DBUIFunc = utils.misc.db_ui_info




-- TODO 
--[[ VenomEnv = get_venom
gls.left[17] = {
  PythonEnv = {
    provider = VenomEnv,
    highlight = {colors.yellow,colors.bg},
  }
}
 ]]

local function get_condition(type)
 local function condition()
   local cur_tab = vim.fn.tabpagenr()
   local all_nr = {}
   for key, tab in pairs(vim.fn.gettabinfo()) do
     table.insert(all_nr, tab.tabnr)
   end

   local max = all_nr[#all_nr]
   if type == 'checkleft' then
     return (cur_tab > 1 ) and (#all_nr > 1)
   elseif type == 'checkright' then
     return cur_tab < max
   end
 end
 return condition
end


-- TODO: Reload ends up inserting again. Refactor back to index.

gls.right[1] = {
  TabInfoLeft = {
    condition = get_condition('checkleft'),
    provider = utils.stabline.render_left_tabs(nil, '│', 'name_only'),
    -- provider = utils.stabline.render_left_tabs(nil, '│', 'name_only'),
    -- seperator = '┼',
    highlight = {colors.fg, colors.bg},
    separator = "",
  }
}


gls.right[2] = {
  TabInfoCurrent = {
    provider = utils.stabline.render_current_tab(nil, '│', '│', 'name_only'),
    highlight = {colors.fg, colors.darkblue, 'bold'},
  }
}

gls.right[3] = {
  TabInfoRight = {
    condition = get_condition('checkright'),
    provider = utils.stabline.render_right_tabs(nil, '│', 'name_only'),
    highlight = {colors.fg, colors.bg}
  }
}


gls.right[4] = {
  FileFormat = {
    provider = 'FileFormat',
    separator = ' ',
    separator_highlight = {colors.bg,colors.line_bg},
    highlight = {colors.fg,colors.line_bg,'bold'},
  }
}
gls.right[5] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = {colors.blue,colors.line_bg},
    highlight = {colors.fg,colors.line_bg},
  },
}
gls.right[6] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {colors.line_bg,colors.line_bg},
    highlight = {colors.cyan,colors.darkblue,'bold'},
  }
}

--[[ gls.right[5] = {
  ScrollBar = {
    provider = 'ScrollBar',
    highlight = {colors.blue,colors.purple},
  }
} ]]

--[[ gls.right[17] = {
  DBUIFunc = {
    provider = DBUIFunc,
    icon = '   ',
    highlight = {colors.yellow,colors.bg},
  }
}

gls.right[3] = {
  Vista = {
    provider = VistaPlugin,
    separator = ' ',
    separator_highlight = {colors.bg,colors.line_bg},
    highlight = {colors.fg,colors.line_bg,'bold'},
  }
} ]]

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = '',
    condition = has_file_type,
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.fg,colors.purple}
  }
}


gls.short_line_right[2] = {
  BufferIcon = {
    provider= 'BufferIcon',
    separator = '',
    condition = has_file_type,
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.fg,colors.purple}
  }
}
