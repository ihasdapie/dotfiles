local wk = require('which-key')

wk.setup({
    preset = "classic",
    delay = function(ctx)
        return ctx.plugin and 0 or 200
    end,
    plugins = {
        marks = true,
        registers = true,
        spelling = {
            enabled = true,
            suggestions = 20,
        },
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
        },
    },
    win = {
        border = "single",
        padding = { 1, 2 },
    },
    layout = {
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
    },
    icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
    },
    replace = {
        key = {
            { "<Space>", "SPC" },
            { "<cr>", "RET" },
            { "<tab>", "TAB" },
        },
    },
    show_help = true,
})

-- Normal mode mappings
wk.add({
    -- g mappings
    { "gF", "<cmd>silent! !xdg-open <cfile> &<CR>", desc = "XDG-open in external program" },

    -- Base-level mappings
    { "[g", "<Plug>(coc-diagnostic-prev)", desc = "previous coc-diagnostic" },
    { "]g", "<Plug>(coc-diagnostic-next)", desc = "next coc-diagnostic" },
    { "gd", "<Plug>(coc-definition)", desc = "coc-definition" },
    { "gy", "<Plug>(coc-type-definition)", desc = "coc-type-definition" },
    { "gI", "<Plug>(coc-implementation)", desc = "coc-implementation" },
    { "gr", "<Plug>(coc-references)", desc = "coc-references" },

    -- Leader mappings
    { "<leader><leader>", "<cmd>WhichKey<CR>", desc = "WhichKey bindings" },

    -- Buffer
    { "<leader>b", group = "buffer" },
    { "<leader>bn", "<cmd>bnext<CR>", desc = "Next buffer" },
    { "<leader>bp", "<cmd>bprev<CR>", desc = "Previous buffer" },
    { "<leader>bd", "<cmd>Bdelete<CR>", desc = "delete current buffer" },
    { "<leader>bb", "<cmd>Telescope buffers theme=ivy<CR>", desc = "list buffers" },

    -- Code
    { "<leader>c", group = "code" },
    { "<leader>cA", "<Plug>(coc-codeaction)", desc = "code action" },
    { "<leader>cL", "<Plug>(coc-codeaction-line)", desc = "code action (line)" },
    { "<leader>ca", "<Plug>(coc-codeaction-cursor)", desc = "code action(cursor)" },
    { "<leader>cc", "<cmd>CocList --ignore-case commands<CR>", desc = "list avaliable commands" },
    { "<leader>cd", "<cmd>lua require('neogen').generate()<CR>", desc = "generate documentation template" },
    { "<leader>cf", "<Plug>(coc-fix-current)", desc = "code fix" },
    { "<leader>cF", "<cmd>call CocAction('format')<CR>", desc = "format" },
    { "<leader>ci", "<cmd>call ShowDocFloat()<CR>", desc = "info hover" },
    { "<leader>cl", "<Plug>(coc-codelens-action)", desc = "code lens action" },
    { "<leader>ct", "<cmd>Tags<CR>", desc = "list tags" },
    { "<leader>cr", "<Plug>(coc-rename)", desc = "rename" },
    { "<leader>cs", "<cmd>CocCommand clangd.switchSourceHeader<CR>", desc = "switch source/header (clangd-only)" },
    { "<leader>cR", "<cmd>SnipRun<CR>", desc = "sniprun" },
    { "<leader>cC", "<cmd>ClaudeCode<CR>", desc = "claude code" },

    -- Code: Golang
    { "<leader>cg", group = "golang" },
    { "<leader>cgf", "<cmd>GoFillStruct<CR>", desc = "fill struct" },
    { "<leader>cgc", "<cmd>GoCallers<CR>", desc = "GoCallers" },
    { "<leader>cgt", "<cmd>CocCommand go.test.toggle<CR>", desc = "toggle go test" },

    -- Code: Misc
    { "<leader>cm", group = "misc" },
    { "<leader>cmr", "<cmd>CocRestart<CR>", desc = "Restart coc.nvim" },
    { "<leader>cmR", "<cmd>CocRebuild<CR>", desc = "rebuild coc.nvim" },
    { "<leader>cmw", ":%s/\\s\\+$//e<CR>", desc = "Delete all trailing whitespace" },

    -- Code: Pick
    { "<leader>cp", group = "pick" },
    { "<leader>cph", "<cmd>Pickachu color hex<CR>", desc = "hex color" },
    { "<leader>cpf", "<cmd>Pickachu file<CR>", desc = "file" },
    { "<leader>cpd", "<cmd>Pickachu date<CR>", desc = "date" },

    -- Edit
    { "<leader>e", group = "edit" },
    { "<leader>er", ":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>", desc = "Edit register" },

    -- Debug
    { "<leader>d", group = "debug" },
    { "<leader>dO", "<cmd>lua require('dapui').open()<CR>", desc = "open dapui" },
    { "<leader>dC", "<cmd>lua require('dapui').close()<CR>", desc = "close dapui" },
    { "<leader>dc", "<cmd>lua require('dap').continue()<CR>", desc = "continue" },
    { "<leader>di", "<cmd>lua require('dap.ui.widgets').hover()<CR>", desc = "info" },
    { "<leader>dk", "<cmd>lua require('dap').step_over()<CR>", desc = "step over" },
    { "<leader>dl", "<cmd>lua require('dap').step_into()<CR>", desc = "step into" },
    { "<leader>dL", "<cmd>lua require('dap').step_out()<CR>", desc = "step out" },
    { "<leader>dp", "<cmd>lua require('dap').pause()<CR>", desc = "pause" },
    { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "breakpoint toggle" },
    { "<leader>dr", "<cmd>lua require('dap').repl.open()<CR>", desc = "repl" },
    { "<leader>dR", "<cmd>lua require('dap').run_last()<CR>", desc = "run last" },
    { "<leader>dx", "<cmd>lua require('dap').terminate()<CR>", desc = "termiante" },

    -- Files
    { "<leader>f", group = "files" },
    { "<leader>fr", "<cmd>History<CR>", desc = "History" },
    { "<leader>ff", "<cmd>Files<CR>", desc = "List @ CWD" },
    { "<leader>fp", "<cmd>Files ../<CR>", desc = "List @ parent" },
    { "<leader>fs", "<cmd>w<CR>", desc = "Save" },
    { "<leader>fP", "<cmd>Files ~/.config/nvim/<CR>", desc = "Open config files" },
    { "<leader>fn", "<cmd>DashboardNewFile<CR>", desc = "new file" },
    { "<leader>fd", "<cmd>DiffChangesDiffToggle<CR>", desc = "vimdiff unsaved buffer with saved" },
    { "<leader>fD", "<cmd>DiffChangesDiffToggle<CR>", desc = "show patch for unsaved buffer with saved" },

    -- Git
    { "<leader>g", group = "git" },
    { "<leader>gG", "<cmd>Git<CR>", desc = "status" },
    { "<leader>gc", "<cmd>Commits<CR>", desc = "commits" },
    { "<leader>gb", "<cmd>Gitsigns blame<CR>", desc = "git blame" },
    { "<leader>gf", "<cmd>GFiles<CR>", desc = "search git files" },
    { "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "stage hunk" },
    { "<leader>gS", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "undo_stage hunk" },
    { "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", desc = "next hunk" },
    { "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", desc = "previous hunk" },
    { "<leader>gB", "<cmd>Gitsigns stage_buffer<CR>", desc = "stage buffer" },
    { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "reset hunk" },
    { "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "reset buffer" },
    { "<leader>gP", "<cmd>Gitsigns preview_hunk<CR>", desc = "preview hunk" },
    { "<leader>gy", desc = "Copy git link" },

    -- Git: List
    { "<leader>gl", group = "list" },
    { "<leader>glc", "<cmd>Commits<CR>", desc = "Commits" },

    -- Help
    { "<leader>h", group = "help" },
    { "<leader>ht", "<cmd>Telescope colorscheme<CR>", desc = "colorscheme" },
    { "<leader>hc", "<cmd>Commands<CR>", desc = "commands" },
    { "<leader>hs", "<cmd>Helptags<CR>", desc = "search help" },

    -- Help: History
    { "<leader>hh", group = "history" },
    { "<leader>hhf", "<cmd>History<CR>", desc = "recent files" },
    { "<leader>hhc", "<cmd>History:<CR>", desc = "recent commands" },
    { "<leader>hhs", "<cmd>History/<CR>", desc = "recent searchs" },

    -- Help: Packages
    { "<leader>hp", group = "packages" },
    { "<leader>hpi", "<cmd>PlugInstall<CR>", desc = "install Packages" },
    { "<leader>hpc", "<cmd>PlugClean<CR>", desc = "clean Packages" },
    { "<leader>hpu", "<cmd>PlugUpdate<CR>", desc = "update Packages" },

    -- Help: Reload
    { "<leader>hr", group = "reload" },
    { "<leader>hrr", "<cmd>Reload<CR>", desc = "Reload Configuration" },
    { "<leader>hrb", "<cmd>Whichkey<CR>", desc = "Which-key" },

    -- List
    { "<leader>l", group = "list" },
    { "<leader>ly", "<cmd>CocList -A --normal yank<CR>", desc = "yank" },
    { "<leader>lo", "<cmd>CocList -A outline<CR>", desc = "outline" },
    { "<leader>ls", "<cmd>CocList -A symbols<CR>", desc = "outline" },
    { "<leader>ld", "<cmd>CocList -A diagnostics", desc = "diagnostics" },
    { "<leader>lm", "<cmd>Telescope marks<CR>", desc = "marks" },

    -- Project
    { "<leader>p", group = "project" },
    { "<leader>ps", "<cmd>cd %:h<CR>", desc = "change pwd to current file" },
    { "<leader>pc", "<cmd>FzfChooseProjectFile<CR>", desc = "choose project file" },
    { "<leader>pp", "<cmd>FzfSwitchProject<CR>", desc = "switch project" },

    -- Window
    { "<leader>w", group = "window" },
    { "<leader>wm", "<cmd>WinShift<CR>", desc = "rearrange windows" },
    { "<leader>ws", "<cmd>split<CR>", desc = "horizontal split" },
    { "<leader>wv", "<cmd>vsplit<CR>", desc = "vertical split" },
    { "<leader>wc", "<cmd>close<CR>", desc = "close" },
    { "<leader>wd", "<cmd>close<CR>", desc = "close" },
    { "<leader>wq", "<cmd>close<CR>", desc = "close" },
    { "<leader>wp", "<cmd>Windows<CR>", desc = "pick" },
    { "<leader>wW", "<cmd>Windows<CR>", desc = "pick" },
    { "<leader>wt", "<cmd>MaximizerToggle!<CR>", desc = "toggle maximize window" },
    { "<leader>wh", "<cmd>wincmd h<CR>", desc = "select left" },
    { "<leader>wj", "<cmd>wincmd j<CR>", desc = "select below" },
    { "<leader>wk", "<cmd>wincmd k<CR>", desc = "select above" },
    { "<leader>wl", "<cmd>wincmd l<CR>", desc = "select right" },
    { "<leader>wH", "<cmd>wincmd H<CR>", desc = "move to very left" },
    { "<leader>wJ", "<cmd>wincmd J<CR>", desc = "move to very bottom" },
    { "<leader>wK", "<cmd>wincmd K<CR>", desc = "move to very top" },
    { "<leader>wL", "<cmd>wincmd L<CR>", desc = "move to very right" },
    { "<leader>wT", "<cmd>wincmd T<CR>", desc = "break out to new tab" },
    { "<leader>wx", "<cmd>wincmd x<CR>", desc = "swap windows" },
    { "<leader>w>", "<cmd>20 wincmd > <CR>", desc = "increase size" },
    { "<leader>w<lt>", "<cmd>20 wincmd <lt> <CR>", desc = "decrease size" },
    { "<leader>w=", "<cmd>wincmd = <CR>", desc = "equal size" },

    -- Search
    { "<leader>s", group = "search" },
    { "<leader>sc", "<cmd>Commands<CR>", desc = "commands" },
    { "<leader>sp", "<cmd>Rg<CR>", desc = "all files at cwd" },
    { "<leader>sP", "<cmd>RG<CR>", desc = "all files at cwd + regex" },
    { "<leader>sB", "<cmd>Lines<CR>", desc = "open buffers" },
    { "<leader>sb", "<cmd>BLines<CR>", desc = "current buffer" },
    { "<leader>ss", "<cmd>Vista finder<CR>", desc = "symbols" },
    { "<leader>sf", "<cmd>GrugFar<CR>", desc = "grug-far" },
    { "<leader>sr", ":CocSearch ", desc = "search-and-replace" },
    { "<leader>sw", "<cmd>RgWordUnderCursor<CR>", desc = "word under cursor" },

    -- Search: History
    { "<leader>sh", group = "history" },
    { "<leader>shc", "<cmd>History:<CR>", desc = "commands" },
    { "<leader>shs", "<cmd>History/<CR>", desc = "search" },
    { "<leader>shf", "<cmd>History<CR>", desc = "files" },

    -- Tab
    { "<leader>T", group = "tab" },
    { "<leader>Tn", "<cmd>tabnew<CR>", desc = "new" },
    { "<leader>Tl", "<cmd>tabm +1<CR>", desc = "move right" },
    { "<leader>Th", "<cmd>tabm -1<CR>", desc = "move left" },
    { "<leader>Tc", "<cmd>tabclose<CR>", desc = "close" },
    { "<leader>Te", ":tabedit <TAB>", desc = "edit" },

    -- Toggle
    { "<leader>t", group = "toggle" },
    { "<leader>tn", "<cmd>lua NI_cycle_number()<CR>", desc = "cycle line numbers" },
    { "<leader>tt", "<cmd>FloatermToggle<CR>", desc = "toggle Floaterm" },
    { "<leader>th", "<cmd>noh<CR>", desc = "hide current search highlighting" },
    { "<leader>tH", "<cmd>set invhlsearch<CR>", desc = "toggle search highlighting" },
    { "<leader>ti", "<cmd>IndentBlanklineToggle<CR>", desc = "toggle indent guides" },
    { "<leader>tu", "<cmd>UndotreeToggle<CR>", desc = "toggle undotree" },
    { "<leader>tp", "<cmd>lua NI_cycle_prose()<CR>", desc = "toggle prose mode" },
    { "<leader>tv", "<cmd>Vista!!<CR>", desc = "toggle vista symbol tree" },
    { "<leader>tc", "<cmd>lua NI_cycle_conceallevel()<CR>", desc = "toggle conceallevel" },
    { "<leader>te", "<cmd>NnnExplorer<CR>", desc = "NnnExplorer sidebar" },
    { "<leader>ts", "<cmd>set spell! spell?<CR>", desc = "spellcheck" },
    { "<leader>tf", "za", desc = "toggle fold under cursor" },
    { "<leader>tl", '<cmd>set autoread | au CursorHold * checktime | call feedkeys("G")<CR>', desc = "toggle log tail mode" },

    -- Toggle: Treesitter
    { "<leader>tT", group = "treesitter" },
    { "<leader>tTc", "<cmd>TSContextToggle<CR>", desc = "toggle context" },
    { "<leader>tTh", "<cmd>TSBufToggle highlight<CR>", desc = "toggle syntax highlight" },
    { "<leader>tTs", "<cmd>TSBufToggle refactor.highlight_current_scope<CR>", desc = "toggle highlight current scope" },

    -- Misc
    { "<leader>m", group = "misc" },
    { "<leader>md", '<cmd>lua require("duck").hatch()<CR>', desc = "release a duck" },
    { "<leader>mD", '<cmd>lua require("duck").cook()<CR>', desc = "cook a duck" },

    -- Misc: Change
    { "<leader>mc", group = "change" },
    { "<leader>mcd", "<cmd>cd %:p:h<CR>", desc = "change cwd to current file" },

    -- Open
    { "<leader>o", group = "open" },
    { "<leader>ot", "<cmd>FloatermNew<CR>", desc = "new floatterm" },
    { "<leader>op", "<cmd>CocCommand explorer<CR>", desc = "project sidebar" },
    { "<leader>of", "<cmd>call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])<CR>", desc = "open file in project sidebar" },

    -- Quit
    { "<leader>q", group = "quit" },
    { "<leader>qa", "<cmd>qa<CR>", desc = "quit all" },

    -- Localleader
    { "<localleader>w", "<cmd>w<CR>", desc = "Save file" },
    { "<localleader>p", '"+p', desc = "Paste from system clipboard" },
    { "<localleader>P", "<cmd>call mdip#MarkdownClipboardImage()<CR>", desc = "Paste image" },
    { "<localleader>y", '"+y', desc = "Copy to system clipboard" },
    { "<localleader>v", "<cmd>lua require('nabla').popup()<CR>", desc = "preview LaTeX math" },
    { "<localleader>V", "<cmd>lua Toggle_venn()<CR>", desc = "toggle diagram drawer" },
    { "<localleader>m", "<cmd>lua require('dap').step_into()<CR>", desc = "step into" },
    { "<localleader>l", "<cmd>lua require('dap').step_over()<CR>", desc = "step over" },
    { "<localleader>k", "<cmd>lua require('dap').step_out()<CR>", desc = "step out" },
    { "<localleader>r", "<cmd>History:<CR>", desc = "recent commands" },

    -- Localleader: Floaterm
    { "<localleader>t", group = "floaterm" },
    { "<localleader>tl", "<cmd>FloatermNext<CR>", desc = "next floaterm" },
    { "<localleader>th", "<cmd>FloatermPrev<CR>", desc = "prev floaterm" },
    { "<localleader>tt", "<cmd>FloatermToggle<CR>", desc = "toggle floaterm" },
    { "<localleader>tn", "<cmd>FloatermNew<CR>", desc = "new floaterm" },
    { "<localleader>tq", "<cmd>FloatermKill<CR>", desc = "close floaterm" },
    { "<localleader>tc", "<cmd>FloatermKill<CR>", desc = "close floaterm" },
    { "<localleader>td", "<cmd>FloatermKill<CR>", desc = "close floaterm" },
})

-- Visual mode mappings
wk.add({
    { "<leader>c", group = "code", mode = "x" },
    { "<leader>ca", "<Plug>(coc-codeaction-selected)", desc = "codeaction", mode = "x" },
    { "<leader>cR", "<cmd>SnipRun<CR>", desc = "sniprun", mode = "x" },
    { "<leader>cf", "<Plug>(coc-format-selected)", desc = "code format selected", mode = "x" },
    { "<leader>g", group = "git", mode = "x" },
    { "<leader>gy", desc = "Copy git link", mode = "x" },
})

-- Insert mode mappings (Leader = <C-x>)
wk.add({
    { "<C-x>f", "fzf#vim#complete#path('rg--files')", desc = "Insert file name", mode = "i", expr = true },
    { "<C-x><tab>", "<C-x><C-o>", desc = "complete omnifunc", mode = "i" },
    { "<C-x>i", "<C-x><C-o>", desc = "complete omnifunc", mode = "i" },
    { "<C-x>s", "<cmd>call CocActionAsync('showSignatureHelp')<CR>", desc = "Show function signature help", mode = "i" },
})

-- TODO: Map <cmd>Man<CR> somewhere -- gives vim help for thing under cursor
