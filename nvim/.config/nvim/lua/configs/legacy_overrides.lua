-- legacy_overrides.lua — sourced AFTER nvim-arm/keybindings.vim and the
-- nvim-arm/lua/which-key_config.lua have run. Patches anything that hard-
-- codes coc.nvim Plug mappings, calls coc autoload functions, or assumes
-- plugins we removed in nvim-fast-2.
--
-- Goal: every binding from the original config still works (or gracefully
-- falls back), without needing to touch the shared nvim-arm files.

local map = vim.keymap.set
local wk_ok, wk = pcall(require, "which-key")

-- ---------------------------------------------------------------------------
-- 1. Cancel coc#float#* mappings on <C-f> / <C-b>.
--    keybindings.vim binds these to coc autoload functions which don't exist
--    in nvim-fast-2, so pressing <C-f> in a buffer would otherwise throw
--    `E117: Unknown function: coc#float#has_scroll`. Restore the vim defaults
--    (page-down / page-up). In insert mode, give them to nvim-cmp scroll.
for _, m in ipairs({ "n", "x", "v" }) do
    pcall(vim.keymap.del, m, "<C-f>")
    pcall(vim.keymap.del, m, "<C-b>")
end
pcall(vim.keymap.del, "i", "<C-f>")
pcall(vim.keymap.del, "i", "<C-b>")
-- Restore vim's defaults explicitly so nothing else (e.g. an autocmd) is
-- tempted to leave an empty mapping.
map({ "n", "x", "v" }, "<C-f>", "<C-f>", { desc = "Page down" })
map({ "n", "x", "v" }, "<C-b>", "<C-b>", { desc = "Page up" })

-- ---------------------------------------------------------------------------
-- 2. Replace which-key entries that point to coc Plug mappings or coc
--    autoload functions with the native LSP / Telescope / Diagnostic
--    equivalents. wk.add is a no-op when the plugin isn't loaded yet, so
--    only run if we have it.
-- Helper: replace a binding cleanly (delete then set) so which-key's
-- internal mappings table doesn't end up with a duplicate entry next to the
-- old coc-Plug version.
local function replace(modes, lhs, rhs, desc, opts)
    if type(modes) == "string" then modes = { modes } end
    for _, m in ipairs(modes) do
        pcall(vim.keymap.del, m, lhs)
    end
    vim.keymap.set(modes, lhs, rhs, vim.tbl_extend("force",
        { silent = true, desc = desc }, opts or {}))
end

-- Diagnostics navigation (was [g / ]g → coc-diagnostic-prev/next).
-- Use the modern vim.diagnostic.jump() API; jump.float = true in
-- configs/lsp.lua makes the diagnostic float pop up after each jump.
replace("n", "[g", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
replace("n", "]g", function() vim.diagnostic.jump({ count =  1 }) end, "Next diagnostic")

-- fzf.vim (:Files / :Rg / :Buffers / etc.) opens a terminal window. nvim's
-- default <Esc> in terminal mode sends \e to the program — fzf takes that
-- as cancel and closes. But: depending on snacks.terminal's double-esc
-- swallow, noice's cmdline routing, and which-key delays, the literal
-- <Esc> sometimes never reaches fzf and you're stuck. Force <Esc> in any
-- buffer with filetype=fzf to send <C-c> instead, which fzf always treats
-- as cancel. Single press closes. Double press doesn't matter — first one
-- already closed.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "fzf",
    callback = function(args)
        vim.keymap.set("t", "<Esc>", "<C-c>", { buffer = args.buf, desc = "fzf cancel" })
        vim.keymap.set("t", "<Esc><Esc>", "<C-c>", { buffer = args.buf, desc = "fzf cancel" })
    end,
})

-- gd/gy/gI/gr: DON'T re-bind globally. Two reasons:
--   1. lua/configs/lsp.lua's on_attach sets them buffer-locally to the right
--      vim.lsp.buf.* function, so they work the moment an LSP attaches.
--   2. nvim 0.11 ships built-in defaults: grr (references), grn (rename),
--      gra (code action), gri (implementation), grt (type def). A global
--      gr/gd binding overlaps with grr/grt/etc. and adds 420 ms delay on
--      every press while which-key disambiguates.
-- We just delete the inherited coc-Plug bindings so they don't error.
for _, k in ipairs({ "gd", "gy", "gI", "gr" }) do
    pcall(vim.keymap.del, "n", k)
end

-- <leader>c* code actions
replace("n", "<leader>cA", function() vim.lsp.buf.code_action() end, "code action")
replace("n", "<leader>cL", function() vim.lsp.buf.code_action({ range = { start = { vim.fn.line("."), 0 }, ["end"] = { vim.fn.line("."), 99999 } } }) end, "code action (line)")
replace("n", "<leader>ca", function() vim.lsp.buf.code_action() end, "code action (cursor)")
replace("n", "<leader>cf", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "quickfix" } } }) end, "quickfix code action")
replace("n", "<leader>cF", function() require("conform").format({ async = false, lsp_fallback = true }) end, "format")
replace("n", "<leader>ci", function() vim.lsp.buf.hover() end, "info hover")
replace("n", "<leader>cl", function() vim.lsp.codelens.run() end, "code lens action")
replace("n", "<leader>cr", function() vim.lsp.buf.rename() end, "rename")

-- clangd switchSourceHeader: clangd custom request, not a workspace command.
replace("n", "<leader>cs", function()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "clangd" })
    if #clients == 0 then
        vim.notify("[nvim-fast-2] clangd not attached", vim.log.levels.WARN)
        return
    end
    local params = vim.lsp.util.make_text_document_params()
    clients[1]:request("textDocument/switchSourceHeader", params, function(_, result)
        if result then vim.cmd("edit " .. vim.uri_to_fname(result)) end
    end, 0)
end, "switch source/header (clangd)")

-- <leader>cm* misc
replace("n", "<leader>cmr", "<cmd>LspRestart<cr>", "Restart LSP")
replace("n", "<leader>cmR", "<cmd>Mason<cr>",      "Mason (rebuild)")

-- :Tags falls back to LSP workspace symbols when no tagfile.
replace("n", "<leader>ct", function()
    if vim.fn.filereadable(vim.fn.findfile("tags", ".;")) == 1 then
        vim.cmd("Tags")
    else
        require("telescope.builtin").lsp_workspace_symbols()
    end
end, "tags / workspace symbols")

-- Reveal current file in neo-tree sidebar (was coc-explorer reveal).
replace("n", "<leader>of", "<cmd>Neotree reveal left<cr>",
    "reveal current file in sidebar")

-- Visual mode overrides
replace("x", "<leader>ca", function() vim.lsp.buf.code_action() end, "code action (visual)")
replace("x", "<leader>cf", function()
    require("conform").format({ async = false, lsp_fallback = true, range = {
        start = vim.api.nvim_buf_get_mark(0, "<"),
        ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
    } })
end, "format selection")

-- duck.nvim stubs (not installed)
replace("n", "<leader>md", function()
    vim.notify("[nvim-fast-2] duck.nvim not installed", vim.log.levels.INFO)
end, "release a duck (stubbed)")
replace("n", "<leader>mD", function()
    vim.notify("[nvim-fast-2] duck.nvim not installed", vim.log.levels.INFO)
end, "cook a duck (stubbed)")

-- Insert-mode signature help (<C-x>s referenced CocActionAsync).
replace("i", "<C-x>s", function() vim.lsp.buf.signature_help() end, "signature help")

-- Strip coc/Plug entries from which-key's mapping registry so its UI doesn't
-- show stale labels. which-key v3 stores them in an internal table; we walk
-- it and drop anything whose RHS still references coc.
if wk_ok then
    local state_ok, state = pcall(require, "which-key.state")
    if state_ok and state.mappings then
        local new = {}
        for _, m in ipairs(state.mappings) do
            local rhs = type(m.rhs) == "string" and m.rhs or ""
            if not (rhs:match("coc%-") or rhs:match("CocAction") or rhs:match("CocCommand") or rhs:match("ShowDocFloat")) then
                table.insert(new, m)
            end
        end
        state.mappings = new
    end
end

-- ---------------------------------------------------------------------------
-- 3. Define VisualSelection() so the `*` and `#` mappings in
--    keybindings.vim (which call it via `:call VisualSelection('','')`)
--    don't throw E117. Original nvim-arm leaves this undefined too — we're
--    fixing a latent bug for free.
vim.cmd([[
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
]])

-- ---------------------------------------------------------------------------
-- 4. Port the VimTeX which-key descriptions from nvim-arm/lua/vimtex_bindings.lua
--    (which uses the deprecated wk.register API and isn't required from
--    nvim-fast-2's plugin specs). Re-emit them with the modern wk.add API
--    on FileType tex so VimTeX users still get hint labels.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function(args)
        if not wk_ok then return end
        wk.add({
            { "dse", desc = "vimtex env-delete", buffer = args.buf },
            { "dsc", desc = "vimtex cmd-delete", buffer = args.buf },
            { "ds$", desc = "vimtex env-delete-math", buffer = args.buf },
            { "dsd", desc = "vimtex delim-delete", buffer = args.buf },
            { "cse", desc = "vimtex env-change", buffer = args.buf },
            { "csc", desc = "vimtex cmd-change", buffer = args.buf },
            { "cs$", desc = "vimtex env-change-math", buffer = args.buf },
            { "csd", desc = "vimtex delim-change-math", buffer = args.buf },
            { "tsc", desc = "vimtex cmd-toggle-star", buffer = args.buf },
            { "tse", desc = "vimtex env-toggle-star", buffer = args.buf },
            { "K",   desc = "vimtex doc-package", buffer = args.buf },
            { "<localleader>l",  group = "vimtex", buffer = args.buf },
            { "<localleader>li", desc = "vimtex info", buffer = args.buf },
            { "<localleader>lI", desc = "vimtex info-full", buffer = args.buf },
            { "<localleader>lt", desc = "vimtex toc-open", buffer = args.buf },
            { "<localleader>lT", desc = "vimtex toc-toggle", buffer = args.buf },
            { "<localleader>lq", desc = "vimtex log", buffer = args.buf },
            { "<localleader>lv", desc = "vimtex view", buffer = args.buf },
            { "<localleader>lr", desc = "vimtex reverse-search", buffer = args.buf },
            { "<localleader>ll", desc = "vimtex compile", buffer = args.buf },
            { "<localleader>lk", desc = "vimtex stop", buffer = args.buf },
            { "<localleader>lK", desc = "vimtex stop-all", buffer = args.buf },
            { "<localleader>le", desc = "vimtex errors", buffer = args.buf },
            { "<localleader>lo", desc = "vimtex compile-output", buffer = args.buf },
            { "<localleader>lg", desc = "vimtex status", buffer = args.buf },
            { "<localleader>lG", desc = "vimtex status-all", buffer = args.buf },
            { "<localleader>lc", desc = "vimtex clean", buffer = args.buf },
            { "<localleader>lC", desc = "vimtex clean-full", buffer = args.buf },
            { "<localleader>lm", desc = "vimtex imaps-list", buffer = args.buf },
            { "<localleader>lx", desc = "vimtex reload", buffer = args.buf },
            { "<localleader>lX", desc = "vimtex reload-state", buffer = args.buf },
            { "<localleader>ls", desc = "vimtex toggle-main", buffer = args.buf },
            { "<localleader>la", desc = "vimtex context-menu", buffer = args.buf },
            { "<localleader>lL", desc = "vimtex compile-selected", buffer = args.buf },
        })
    end,
})

-- ---------------------------------------------------------------------------
-- 5. The `<localleader>` (= `,`) mapping that opens which-key was set in
--    legacy.vim BEFORE which-key loads. Re-bind it now to a function that
--    requires which-key lazily.
map("n", "<localleader>", function()
    local ok, w = pcall(require, "which-key")
    if ok then w.show({ keys = ",", mode = "n", auto = true }) end
end, { desc = "which-key for ,", silent = true })
