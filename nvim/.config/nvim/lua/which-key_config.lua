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
    border = "single", -- none, single, double, shadow
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

wk.register( { -- Normal mode mappings
    g = {
      F = {"<cmd>silent! !xdg-open <cfile> &<CR>", "XDG-open in external program"},
    },

    ["<leader>"] = {
      ['<leader>'] = {"<cmd>WhichKey<CR>", "WhichKey bindings"},
      b = {
          name = "+buffer",
          n = {"<cmd>bnext<CR>", "Next buffer"},
          p = {"<cmd>bprev<CR>", "Previous buffer"},
          -- P = {"<cmd>BufferLinePick<CR>", "Bufferline Pick"},
          -- o = {"<cmd>BufferLineSortByRelativeDirectory<CR>", "Sort by relative directory"},
          d = {"<cmd>Bdelete %<CR>", "delete current buffer"},
          b = {"<cmd>Buffers<CR>", "list buffers"},
      },

      c = {
          name = "+code",
          A = {"<Plug>(coc-codeaction)", "code action"},
          a = {"<Plug>(coc-codeaction-line)", "code action (line)"},
          c = {"<cmd>CocList --ignore-case commands<CR>", "list avaliable commands"},
          f = {"<Plug>(coc-fix-current)", "code fix"},
          r = {"<Plug>(coc-rename)", "rename"},
          l = {"<Plug>(coc-codelens-action)", "code lens action"},
          d = {"<cmd>lua require('neogen').generate()<CR>", "generate documentation template"},
          m = {
              name = "+misc",
              r = {"<cmd>CocRestart<CR>", "Restart coc.nvim"},
              R = {"<cmd>CocRebuild<CR>", "rebuild coc.nvim"},
              w = {":%s/\\s\\+$//e<CR>", "Delete all trailing whitespace"},
          },

          p = {
              name = "+pick",
              h = {"<cmd>Pickachu color hex<CR>", "hex color"},
              f = {"<cmd>Pickachu file<CR>", "file"},
              d = {"<cmd>Pickachu date<CR>", "date"},
            },
          R = {
              name = "+run",
              r = {"<cmd>SnipRun<CR>", 'sniprun'}
            },

          },

      e = {
        name = "+edit",
        -- From https://github.com/mhinz/vim-galore
        -- Takes a register (default *) and opens it in command-line window for editing
        -- Use it like this <leader>er or "q<leader>er.
        r = {":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>", "Edit register"}
      },

      d = {
        name = "+debug",
        c = {"<Plug>VimspectorContinue", "start or continue"},
        S = {"<Plug>VimspectorStop", "stop"},
        R = {"<Plug>VimspectorRestart", "restart"},
        P = {"<Plug>VimspectorPause", "pause debugger"},
        b = {"<Plug>VimspectorToggleBreakpoint", "toggle breakpoint"},
        B = {"<Plug>VimspectorToggleConditionalBreakpoint", "toggle conditional breakpoint"},
        F = {"<Plug>VimspectorAddFunctionBreakpoint", "add function breakpoint"},
        C = {"<Plug>VimspectorRunToCursor", "run to cursor"},
        n = {"<Plug>VimspectorStepOver", "step over"},
        N = {"<Plug>VimspectorStepInto", "step into"},
        o = {"<Plug>VimspectorStepOut", "step out of current"},
        i = {"<Plug>VimspectorBalloonEval", "debug inspect"},
        u = {"<Plug>VimspectorUpFrame", "up stack"},
        d = {"<Plug>VimspectorDownFrame", "down stack"},
      },


      f = {
        name = "+files",
        r = {"<cmd>History<CR>", "History"},
        f = {"<cmd>Files<CR>", "List @ CWD"},
        p = {"<cmd>Files ../<CR>", "List @ parent"},
        s = {"<cmd>w<CR>", "Save"},
        P = {"<cmd>Files ~/.config/nvim/<CR>", "Open config files"},
        n = {"<cmd>DashboardNewFile<CR>", "new file"},
      },

      g = {
        name = "+git",
        G = {"<cmd>Git<CR>", "status"},
        c = {"<cmd>Commits<CR>", "commits"},

        F = {
          name = "+fugitive",
            b = {"<cmd>Git blame<CR>", "blame"},
        },


        f = {"<cmd>GFiles<CR>", "search git files"},
        s = {"<cmd>Gitsigns stage_hunk<CR>", "stage hunk"},
        S = {"<cmd>Gitsigns undo_stage_hunk<CR>", "undo_stage hunk"},
        n = {"<cmd>Gitsigns next_hunk<CR>", "next hunk"},
        p = {"<cmd>Gitsigns prev_hunk<CR>", "previous hunk"},
        B = {"<cmd>Gitsigns stage_buffer<CR>", "stage buffer"},
        r = {"<cmd>Gitsigns reset_hunk<CR>", "reset hunk"},
        R = {"<cmd>Gitsigns reset_buffer<CR>", "reset buffer"},
        P = {"<cmd>Gitsigns preview_hunk<CR>", "preview hunk"},
        l = {
          name = "+list",
          c = {"<cmd>Commits<CR>", "Commits"},
        }

      },


      h = {
        name = "+help",
        t = {"<cmd>Colors<CR>", "colorscheme"},
        c = {"<cmd>Commands<CR>", "commands"},
        s = {"<cmd>Helptags<CR>", "search help"},
        h = {
          name = "+history",
          f = {"<cmd>History<CR>", "recent files"},
          c = {"<cmd>History:<CR>", "recent commands"},
          s = {"<cmd>History/<CR>", "recent searchs"},
        },
        p = {
          name = "+packages",
          i = {"<cmd>PlugInstall<CR>", "install Packages"},
          c = {"<cmd>PlugClean<CR>", "clean Packages"},
          u = {"<cmd>PlugUpdate<CR>", "update Packages"},
        },
        r = {
            name = "+reload",
            r = {"<cmd>Reload<CR>", "Reload Configuration"},
            b = {"<cmd>Whichkey<CR>", "Which-key"}
        },
      },




      l = {
        name = "+list",
        y = {"<cmd>CocList -A --normal yank<CR>", "yank"},
        o = {"<cmd>CocList -A outline<CR>", "outline"},
        s = {"<cmd>CocList -A symbols<CR>", "outline"},
        d = {"<cmd>CocList -A diagnostics", "diagnostics"},
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
        m = {"<cmd>WinShift<CR>", "rearrange windows"},
        s = {"<cmd>split<CR>", "horizontal split"},
        v = {"<cmd>vsplit<CR>", "vertical split"},
        c = {"<cmd>close<CR>", "close"},
        d = {"<cmd>close<CR>", "close"},
        q = {"<cmd>close<CR>", "close"},
        p = {"<cmd>Windows<CR>", "pick"},
        W = {"<cmd>Windows<CR>", "pick"},

        t = {"<cmd>MaximizerToggle!<CR>", "toggle maximize window"},

        h = {"<cmd>wincmd h<CR>", "select left"},
        j = {"<cmd>wincmd j<CR>", "select below"},
        k = {"<cmd>wincmd k<CR>", "select above"},
        l = {"<cmd>wincmd l<CR>", "select right"},
        H = {"<cmd>wincmd H<CR>", "move to very left"},
        J = {"<cmd>wincmd J<CR>", "move to very bottom"},
        K = {"<cmd>wincmd K<CR>", "move to very top"},
        L = {"<cmd>wincmd L<CR>", "move to very right"},

        T = {"<cmd>wincmd T<CR>", "break out to new tab"},
        x = {"<cmd>wincmd x<CR>", "swap windows"},
        [">"] = {"<cmd>20 wincmd > <CR>", "increase size"},
        ["<lt>"] = {"<cmd>20 wincmd <lt> <CR>", "decrease size"},
        ["="] = {"<cmd>wincmd = <CR>", "equal size"},

      },


      s = {
        name = "+search",
        c = {"<cmd>Commands<CR>", "commands"},
        p = {"<cmd>Rg<CR>", "all files at cwd"},
        P = {"<cmd>RG<CR>", "all files at cwd + regex"},
        B = {"<cmd>Lines<CR>", "open buffers"}, b = {"<cmd>BLines<CR>", "current buffer"},
        s = {"<cmd>Vista finder<CR>", "symbols"},
        r = {":CocSearch ", "search-and-replace"},
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
        p = {"<cmd>call Prose_mode()<CR>", "toggle prose mode"},
        v = {"<cmd>Vista!!<CR>", 'toggle vista symbol tree'},
        c = {"<cmd>ColorizerToggle<CR>", "toggle colorization"},
        e = {"<cmd>CocCommand explorer<CR>", "project sidebar"},
        s = {"<cmd>set spell! spell?<CR>", "spellcheck"},
        f = {"za", "toggle fold under cursor"}, -- Just `za` but remapped under leader. Can remove.
        T = {
          name = "+treesitter",
          c = {"<cmd>TSContextToggle<CR>", "toggle context"},
          h = {"<cmd>TSBufToggle highlight<CR>", "toggle syntax highlight"},
          s = {"<cmd>TSBufToggle refactor.highlight_current_scope<CR>", "toggle highlight current scope"},

        }

      },


      m  = {
        name = "+misc",
        c = {
          name = "+change",
          d = {"<cmd>cd %:p:h<CR>", "change cwd to current file"},
        }
      },

      o = {
          name = "+open",
          t = {"<cmd>FloatermNew<CR>", "new floatterm"},
          p = {"<cmd>CocCommand explorer<CR>", "project sidebar"}
      },

      q = {
        name = "+quit",
        a = {"<cmd>qa<CR>", "quit all"},
      },

    },

    ["<localleader>"] = {
      -- Most of these are plugin-specific
      -- We want to change this up because <localleader> l conflicts with vimtex
        w = {"<cmd>w<CR>", "Save file"},
        p = {"\"+p", "Paste from system clipboard"},
        P = {"<cmd>call mdip#MarkdownClipboardImage()<CR>", "Paste image system clipboard"},
        y = {"\"+y", "Copy to system clipboard"},
        lf = {"<cmd>luafile %<CR>", "run current lua file"},

        t = {
          name = "+floaterm",
          l = {"<cmd>FloatermNext<CR>", "next floaterm"},
          j = {"<cmd>FloatermPrev<CR>", "prev floaterm"},
          t = {"<cmd>FloatermToggle<CR>", "toggle floaterm"},
          n = {"<cmd>FloatermNew<CR>", "new floaterm"},
          q = {"<cmd>FloatermKill<CR>", "close floaterm"},
          c = {"<cmd>FloatermKill<CR>", "close floaterm"},
          d = {"<cmd>FloatermKill<CR>", "close floaterm"},
        },

    }
  })



wk.register({ -- base-level mappings
    ["[g"]=  {"<Plug>(coc-diagnostic-prev)", "previous coc-diagnostic"},
    ["]g"]=  {"<Plug>(coc-diagnostic-next)", "next coc-diagnostic"},
    ["gd"]=  {"<Plug>(coc-definition)", "coc-definition"},
    ["gy"]=  {"<Plug>(coc-type-definition)", "coc-type-definition"},
    ["gi"]=  {"<Plug>(coc-implementation)", "coc-implementation"},
    ["gr"]=  {"<Plug>(coc-references)", "coc-references"},
  })


wk.register({ -- Visual mode mappings
    c = {
      name="+code",
      a = {"<Plug>(coc-codeaction-selected", "codeaction"},

      R = {
        name="+run",
        r = {"<cmd>SnipRun", "sniprun"},
      }
      }

  }, {mode='x'})



wk.register({ -- insert mode mappings (Leader = <C-x>))
   f = {"fzf#vim#complete#path('rg--files')", "Insert file name", expr=true},
   ['<tab>'] = {"<C-x><C-o>", "complete omnifunc"},
   i = {"<C-x><C-o>", "complete omnifunc"},


  },
  {mode='i',
    prefix="<C-x>"})











-- TODO: Map <cmd>Man<CR> somewhere -- gives vim help for thing under cursor
