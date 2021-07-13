
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
    padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
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
      b = {
          name = "+buffer",
          p = {"<cmd>BufferLinePick<CR>", "Bufferline Pick"},
          o = {"<cmd>BufferLineSortByRelativeDirectory<CR>", "Sort by relative directory"},
          d = {"<cmd>bdelete %<CR>", "delete current buffer"},
          B = {"<cmd>Buffers<CR>", "list buffers"},
      },

      f = {
        name = "+files",
        r = {"<cmd>History<CR>", "History"},
        f = {"<cmd>Files<CR>", "List @ CWD"},
        p = {"<cmd>Files ../<CR>", "List @ parent"},
        s = {"<cmd>w<CR>", "Save"},
        P = {"<cmd>Files ~/.config/nvim/<CR>", "Open config files"},
        n = {"<cmd>DashboardNewFile<CR>", "New FIle"},
      },

      g = {
        name = "+git",
        G = {"<cmd>Git<CR>", "Status"},

        h = {
          name = "+hunk",

        },
        l = {
          name = "+list",
          c = {"<cmd>Commits<CR>", "Commits"},
        }

      },


      h = {
        name = "+help",
        t = {"<cmd>Colors<CR>", "Colorscheme"},
        m = {"<cmd>Helptags<CR>", "Modules"},
        p = {
          name = "+packages",
          i = {"<cmd>PlugInstall<CR>", "Install Packages"},
          u = {"<cmd>PlugUpdate<CR>", "Update Packages"},
        },
        r = {
            name = "reload",
            r = {"<cmd>Reload<CR>", "Reload Configuration"},
            b = {"<cmd>Whichkey<CR>", "Which-key"}
        },
      },

      l = {
        name = "+list",
        y = {"<cmd>CocList -A --normal yank<CR>", "yank"},
        o = {"<cmd>CocList -A outline<CR>", "outline"},
        m = {"<cmd>Marks<CR>", "marks"},


      },

      p = {
        name = "+project",
        s = {"<cmd>cd %:h<CR>", "change pwd to current file"},
        c = {"<cmd>FzfChooseProjectFile<CR>", "choose project file"},
        p = {"<cmd>FzfSwitchProject<CR>", "switch project"}
      },



      w = {
        name = "+window",
        s = {"<cmd>split<CR>", "Horizontal split"},
        v = {"<cmd>vsplit<CR>", "Vertical split"},
        c = {"<cmd>close<CR>", "Close"},
        d = {"<cmd>close<CR>", "Close"},
        q = {"<cmd>close<CR>", "Close"},
        p = {"<cmd>Windows<CR>", "Pick"},
        W = {"<cmd>Windows<CR>", "Pick"},
        h = {"<cmd>wincmd h<CR>", "Select left"},
        j = {"<cmd>wincmd j<CR>", "Select below"},
        k = {"<cmd>wincmd k<CR>", "Select above"},
        l = {"<cmd>wincmd l<CR>", "Select right"},

        T = {"<cmd>wincmd T<CR>", "Break out to new tab"},
        x = {"<cmd>wincmd x<CR>", "Swap windows"},
        [">"] = {"<cmd>wincmd > <CR>", "Increase size"},
        ["<lt>"] = {"<cmd>wincmd <lt> <CR>", "Decrease size"},
        ["="] = {"<cmd>wincmd = <CR>", "Equal size"},

        K = {"<cmd>wincmd K<CR>", "Arrange horizontally"},
        H = {"<cmd>wincmd H<CR>", "Arrange vertically"},
      },


      s = {
        name = "+search",
        p = {"<cmd>Rg<CR>", "all files at cwd"},
        P = {"<cmd>RG<CR>", "all files at cwd + regex"},

        B = {"<cmd>Lines<CR>", "open buffers"}, b = {"<cmd>BLines<CR>", "current buffer"},
        s = {"<cmd>Vista finder<CR>", "symbols"},
        h = {
            name = "+history",
            c = {"<cmd>History:<CR>", "commands"},
            s = {"<cmd>History/<CR>", "search"},
            f = {"<cmd>History<CR>", "files"}
        }

      }, 

      T = {
          name = "+tab",
          n = {"<cmd>tabnew<CR>", "new"},
          c = {"<cmd>tabclose<CR>", "close"},
          -- e = {'<cmd>tabedit <C-r>=expand(\"%:p:h\")<cr>', "edit"}
          e = {':tabedit <TAB>', "edit"}
      },

      t = {
        name = "+toggle",
        n = {"<cmd>lua MYFUNC.cycle_number()<CR>", "cycle line numbers"},
        t = {"<cmd>FloatermToggle<CR>", "toggle Floaterm"},
        h = {"<cmd>noh<CR>", "hide current search highlighting"},
        H = {"<cmd>set invhlsearch<CR>", "toggle search highlighting"},
        i = {"<cmd>IndentGuidesToggle<CR>", "toggle indent guides"},
        u = {"<cmd>UndotreeToggle<CR>", "toggle undotree"},
        
        T = {
          name = "+treesitter",
          c = {"<cmd>TSContextToggle", "toggle context"},
          h = {"<cmd>TSBufToggle highlight", "toggle syntax highlight"},
          s = {"<cmd>TSBufToggle refactor.highlight_current_scope", "toggle highlight current scope"},

        }

      },


      m  = {
        name = "+misc",
      },

      o = {
          name = "+open",
          t = {"<cmd>FloatermNew<CR>", "new floatterm"},
          f = {"<cmd>CocCommand explorer<CR>", "project sidebar"}

      },

      q = {
        name = "+quit",
        a = {"<cmd>qa<CR>", "quit all"},

      },

    },

    ["<localleader>"] = {
      -- We want to change this up because <localleader> l conflicts with vimtex
      -- and most of the bindings defined here are actually global!
        w = {"<cmd>w<CR>", "Save file"},
        p = {"\"+p", "Paste from system clipboard"},
        h = {"<cmd>BufferLineCyclePrev<CR>", "Previous buffer"},
        l = {"<cmd>BufferLineCycleNext<CR>", "Next buffer"},
        j = {"<cmd>BufferLineMovePrev<CR>", "Move buffer left"},
        k = {"<cmd>BufferLineMoveNextv<CR>", "Move buffer right"},
        y = {"\"+y", "Copy to system clipboard"}
    }
  })





-- TODO: Map <cmd>Man<CR> somewhere -- gives vim help for thing under cursor
--
--
--
--
--
--
--
--
--
--
--
