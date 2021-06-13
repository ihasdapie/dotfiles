
local wk = require('which-key')

wk.setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = "Comments" },

  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    ["<space>"] = "SPC",
    ["<20>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  window = {
    border = "double", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}


wk.register( {

    ["<leader>"] = {
      w = {
        name = "+window",
        s = {"<cmd>split<CR>", "Horizontal split"},
        v = {"<cmd>vsplit<CR>", "Vertical split"},
        c = {"<cmd>close<CR>", "Close"},
        d = {"<cmd>close<CR>", "Close"},
        q = {"<cmd>close<CR>", "Close"},
        p = {"<cmd>Windows<CR>", "Pick"},
        h = {"<cmd>wincmd h<CR>", "Select left"},
        j = {"<cmd>wincmd j<CR>", "Select below"},
        k = {"<cmd>wincmd k<CR>", "Select above"},
        l = {"<cmd>wincmd l<CR>", "Select right"},
        T = {"<cmd>wincmd T<CR>", "Break out to new tab"},
        x = {"<cmd>wincmd x<CR>", "Swap windows"},
        [">"] = {"<cmd>wincmd > <CR>", "Increase size"},
        ["<"] = {"<cmd>wincmd < <CR>", "Decrease size"},
        ["="] = {"<cmd>wincmd = <CR>", "Equal size"},
        K = {"<cmd>wincmd K<CR>", "Arrange horizontally"},
        H = {"<cmd>wincmd H<CR>", "Arrange vertically"},
      },

      b = {
          name = "+buffer",
          p = {"<cmd>BufferLinePick<CR>", "Bufferline Pick"},
          o = {"<cmd>BufferLineSortByRelativeDirectory<CR>", "Sort by relative directory"},
          d = {"<cmd>bdelete %<CR>", "Delete current buffer"},
          l = {"<cmd>Buffers<CR>", "Bufferline list"},
      },

      h = {
        name = "+help",
        t = {"<cmd>Colors<CR>", "Colorscheme"},
        r = "reload",
        ["rr"] = {"<cmd>Reload<CR>", "Reload Configuration"},
        ["kb"] = {"<cmd>Whichkey<CR>", "Which-key"}

      },

      f = {
        name = "+files",
        r = {"<cmd>History<CR>", "History"},
        f = {"<cmd>FZF<CR>", "List @ CWD"},
        p = {"<cmd>FZF ../", "List @ parent"},
        s = {"<cmd>w<CR>", "Save"},
        P = {"<cmd>FZF ~/.config/nvim/ <CR>", "Open config files"}

      },


      m  = {
        name = "+misc",
        h = {"<cmd>noh<CR>", "Turn off highlighting"}
      }

    },

    ["<localleader"] = {
        w = {"<cmd>w<CR>", "Save file"},
        p = {"\"+p", "Paste from system clipboard"}, -- #TODO Make this work!
        y = {"\"+y", "Copys to system clipboard"}
    }
  })






