-- nvim-fast-2: lazy.nvim-managed Lua-first config.
-- The plain ~/.config/nvim install (dotfiles: nvim/); the old vim-plug config
-- lives at ~/.config/nvim-legacy (dotfiles: nvim-legacy/).

-- 0. $HOME is often slow (e.g. bean dev boxes mount it over NFS — ~28x
-- slower than /scratch for metadata-heavy ops; see bean
-- docs/decisions/0010-node-local-nvme-scratch.md). Always prefer fast local
-- disk for plugin installs/mason/venv (stdpath("data")) and shada/swap
-- (stdpath("state")): /scratch when present, else /tmp. legacy.vim mirrors
-- this for undodir/viewdir. Must run before anything below calls stdpath().
-- scripts/migrate-state-to-scratch.sh copies over any existing NFS-resident
-- state (undo history, installed plugins) the first time this runs on a host.
local fs = (vim.uv or vim.loop)
local fast_root = fs.fs_stat("/scratch") and "/scratch/nvim" or fs.fs_stat("/tmp") and "/tmp/nvim"
if not vim.env.XDG_DATA_HOME and fast_root then
    vim.env.XDG_DATA_HOME = fast_root .. "/data"
    vim.env.XDG_STATE_HOME = fast_root .. "/state"
end

-- 1. Built-in bytecode loader (replaces deprecated impatient.nvim)
vim.loader.enable()

-- The cursor "stuck in bottom-right" symptom on cold launch comes from the
-- terminal preserving the shell's last cursor position until nvim's first
-- paint. Force a home + clear + cursor-set the moment a UI attaches so the
-- cursor parks at (1,1) before alpha renders. UIEnter only fires when a
-- real UI is attached (skipped in --headless), so this can't pollute pipes.
vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        io.stdout:write("\27[H\27[2J")
        io.stdout:flush()
        vim.cmd("redraw!")
        pcall(vim.api.nvim_win_set_cursor, 0, { 1, 0 })
    end,
})

-- 1b. Filter deprecation announcer for known-loud, third-party-fix-pending
--     warnings: vim.lsp.buf_get_clients (galaxyline/claudecode), vim.validate
--     (hydra.nvim — fires 7 stack traces during config load). Defer the
--     vim.lsp shim install until first hit so we don't force-load vim.lsp at
--     startup (~1.5 ms cold).
local _swallow = {
    ["vim.lsp.buf_get_clients()"] = true,
    ["vim.lsp.get_active_clients()"] = true,
    ["vim.validate"] = true,           -- hydra.nvim
}
local original_deprecate = vim.deprecate
vim.deprecate = function(name, ...)
    if _swallow[name] then
        if (name == "vim.lsp.buf_get_clients()" or name == "vim.lsp.get_active_clients()")
           and vim.lsp and not vim.lsp.__fast2_shimmed then
            vim.lsp.buf_get_clients = function(bufnr)
                local clients = vim.lsp.get_clients({ bufnr = bufnr or 0 })
                local m = {}
                for _, c in ipairs(clients) do m[c.id] = c end
                return m
            end
            vim.lsp.get_active_clients = function(f) return vim.lsp.get_clients(f) end
            vim.lsp.__fast2_shimmed = true
        end
        return
    end
    return original_deprecate(name, ...)
end

-- 2. Disable the built-in RTP plugins we never use. Saves ~30-50 ms cold.
local rtp_disabled = {
    "gzip", "tar", "tarPlugin", "zip", "zipPlugin", "tutor", "tohtml",
    "rplugin", "matchit", "matchparen", "spellfile_plugin", "getscript",
    "getscriptPlugin", "vimball", "vimballPlugin", "logiPat", "rrhelper",
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
}
for _, p in ipairs(rtp_disabled) do
    vim.g["loaded_" .. p] = 1
end

-- 3. Bootstrap lazy.nvim (clones to stdpath('data')/lazy/lazy.nvim on first run)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    print("[nvim-fast-2] bootstrapping lazy.nvim ...")
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
        }, true, {})
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- 3b. Make the vendored legacy lua modules importable by their bare names
--     (`require("which-key_config")`, `require("hydra_config")`, etc.). These
--     used to be pulled from ~/.config/nvim-arm/lua via package.path; they now
--     live self-contained under lua/legacy/ in this config (copied verbatim
--     from the original vim-plug config). Adding lua/legacy/ to package.path
--     keeps the bare-name require() calls in the plugin specs working without
--     scattering the legacy files across the top-level lua/ dir. We do NOT add
--     it to rtp (no :runtime consumers; rtp-appending another plugin manager's
--     tree triggers lazy.nvim's "Found paths from another plugin manager" error).
local legacy_dir = vim.fn.stdpath("config") .. "/lua/legacy"
package.path = legacy_dir .. "/?.lua;"
            .. legacy_dir .. "/?/init.lua;"
            .. package.path

-- 4. lazy.setup — registers plugins, runs config callbacks for non-lazy ones
--    (kanagawa with priority 1000 loads here and applies colorscheme).
-- Silence missing-provider warnings (we don't use python/perl/ruby/node providers
-- — coc.nvim was the only thing that needed Node's neovim module).
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0       -- python2 not needed

-- python3 provider: point at a dedicated, uv-managed nvim-only venv that holds
-- just `pynvim` (needed by UltiSnips and anything gated on `has('python3')`).
-- Bootstrap it on first launch; stdpath("data") already prefers /scratch, then
-- /tmp, so the venv stays off a potentially slow home filesystem.
local py3 = vim.fn.stdpath("data") .. "/venv/bin/python3"
if not vim.uv.fs_stat(py3) then
    local setup = vim.fn.stdpath("config") .. "/scripts/setup-python-provider.sh"
    print("[nvim-fast-2] bootstrapping Python provider ...")
    local out = vim.fn.system({ setup })
    if vim.v.shell_error ~= 0 then
        vim.schedule(function()
            vim.notify("Failed to bootstrap Python provider:\n" .. out, vim.log.levels.WARN)
        end)
    end
end
if vim.uv.fs_stat(py3) then
    vim.g.python3_host_prog = py3
else
    vim.g.loaded_python3_provider = 0
end

-- Stop vim-pandoc from claiming .md files. Its ftdetect/pandoc.vim defaults
-- to setlocal filetype=pandoc on every markdown variant, which then triggers
-- vim-pandoc + vim-pandoc-syntax + 7 embedded-language syntax files
-- (~700ms+ per .md open). Setting the gate to 0 BEFORE lazy adds the plugin
-- to the rtp keeps .md as native markdown (treesitter handles it).
vim.g["pandoc#filetypes#pandoc_markdown"] = 0

require("lazy").setup({
    spec = { { import = "plugins" } },
    install = { colorscheme = { "kanagawa" } },
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = { disabled_plugins = rtp_disabled },
    },
    change_detection = { enabled = false, notify = false },
    ui = { border = "rounded" },
    -- Disable luarocks; none of our plugins need it
    rocks = { enabled = false, hererocks = false },
})

-- 5. Inline the load-bearing bits from nvim-arm/lua/tmp_init.lua. Avoids a
--    require() round-trip and an early `vim.treesitter` load (~3 ms saved).
vim.o.autoindent     = true
vim.o.smartindent    = true
vim.o.cursorline     = true
vim.o.mouse          = 'a'
vim.g.did_load_filetypes = 1
vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

-- 5b. Typing-latency tuning. Each line is intentional, not aesthetic.
vim.opt.synmaxcol = 240            -- stop syntax highlighting past col 240 (huge minified-file win)
-- shortmess + cmdheight are set AFTER `source legacy.vim` below (see 6b).
-- legacy.vim is sourced verbatim from nvim-arm/init.vim and sets shortmess=atcF
-- and cmdheight=1; setting them here would just get clobbered.

-- "Saner n/N" mappings live AFTER the legacy.vim/keybindings.vim source
-- block below (search for "n_forward"). They have to: legacy.vim used to
-- own them via `nnoremap <expr>`, and that mapping won because it loaded
-- after this point in the file.
vim.opt.ttyfast    = true          -- assume a fast terminal connection
vim.opt.scrolloff  = 4             -- keep 4 lines visible above/below cursor (cheap, prevents redraw thrash on PageDown)
vim.opt.sidescrolloff = 8
vim.opt.regexpengine = 0           -- let vim auto-pick (NFA usually wins on modern syntax files)
vim.opt.history    = 200           -- (default 50; 200 is plenty without bloat)
vim.opt.pumheight  = 12            -- cap completion menu height — fewer rows to render
-- cmdheight is set in 6b below (after legacy.vim, which would clobber it to 1).

-- Remove inactive-window dim ("shadow") globally. kintsugi-flared (and most
-- colorschemes) make NormalNC darker than Normal to indicate which window is
-- focused; that's what causes the visible shadow on the editor when the
-- neo-tree sidebar is focused. Linking NormalNC -> Normal removes the cue.
-- Re-applies on every :colorscheme switch so it survives theme changes.
local function _undim_inactive()
    vim.api.nvim_set_hl(0, "NormalNC", { link = "Normal" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = _undim_inactive })
_undim_inactive()
-- Treesitter folding: install the foldexpr only when treesitter actually
-- parses a buffer, not at startup. Avoids loading vim.treesitter eagerly.
vim.api.nvim_create_autocmd("User", {
    pattern = "TSAttach",
    callback = function(args)
        vim.wo[0][0].foldexpr   = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
    end,
})

-- 6. Source slimmed legacy.vim + keybindings.vim. legacy.vim no longer
--    sources keybindings itself — done here to keep the order obvious.
vim.cmd.source(vim.fn.stdpath("config") .. "/legacy.vim")
vim.cmd.source(vim.fn.stdpath("config") .. "/keybindings.vim")

-- 6b. Re-assert fast-2 overrides AFTER legacy.vim — legacy.vim is sourced
-- verbatim from nvim-arm/init.vim and contains `set shortmess=atcF` (line 41)
-- and `set cmdheight=1` (line 51), which clobber the values set in 5b above.
-- Without re-asserting, the effective runtime values are nvim-arm's, not
-- fast-2's — that's the original cause of the "/notfound → hit-enter" prompt
-- this config tried (and failed) to suppress via cmdheight=2 earlier in the file.
vim.opt.shortmess = "atcFsSI"      -- a=abbreviate, t/c/F=arm baseline, s/S=skip search-noise,
                                   -- I=skip intro. Set explicitly so we don't depend on order.
vim.opt.cmdheight = 2              -- 2 lines fits /pat + E486 stack without hit-enter

-- "Saner n/N": always move to the next match in screen-forward direction
-- regardless of whether search started with / or ?. Wrapped in `silent!`
-- so E486 ("Pattern not found") and the hit-enter prompt that follows it
-- are both swallowed. Has to run AFTER the two :source'd files above —
-- legacy.vim used to own these as `nnoremap <expr>` and that mapping
-- silently overrode any earlier Lua keymap.
--
-- Normal mode → function form so we get `silent!` wrapping. Visual and
-- operator-pending stay <expr>-style: visual-extend semantics and motion
-- composition with d/c/y need the raw key, not a normal! invocation.
-- (The dn-with-no-match path will still hit-enter; that's intentional —
-- you want to know an operator-motion failed.)
local function n_forward()  return (vim.v.searchforward == 1) and "n" or "N" end
local function n_backward() return (vim.v.searchforward == 1) and "N" or "n" end
vim.keymap.set("n", "n", function() vim.cmd("silent! normal! " .. n_forward())  end, { silent = true })
vim.keymap.set("n", "N", function() vim.cmd("silent! normal! " .. n_backward()) end, { silent = true })
vim.keymap.set({ "x", "o" }, "n", n_forward,  { expr = true, silent = true })
vim.keymap.set({ "x", "o" }, "N", n_backward, { expr = true, silent = true })

-- E486 ("Pattern not found") is now handled by cmdheight=2 + shortmess+=a above
-- (was previously also routed through noice; noice has been removed). The
-- previous c<CR> re-execute hack (sent <C-c> then re-typed /pat<CR> via
-- `keepjumps normal!`) was redundant — and worse, it landed the cursor on
-- the 2nd match because the re-search ran from the post-incsearch cursor
-- position, plus interacted badly with flash.nvim's search overlay.
-- Plain `/` now goes straight to the first match. Removed.

-- 7. Define alias commands (PlugInstall→Lazy install, CocList→Telescope, etc.)
--    so the user's existing which-key bindings keep working after the
--    coc/vim-plug/wilder/dashboard-nvim removals.
require("configs.legacy_aliases")

-- 7b. Patch broken bindings inherited from nvim-arm/keybindings.vim and
--     which-key_config.lua. Trigger on lazy.nvim's `User VeryLazy` event
--     instead of VimEnter — this fires AFTER which-key has loaded (it's
--     event = "VeryLazy"), so we don't pay the ~3–4 ms cost of forcing
--     which-key to load early. Drops legacy_overrides from ~5 ms to ~1 ms.
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function() require("configs.legacy_overrides") end,
})

-- 8. Re-enable filetype detection. legacy.vim has `filetype off` (line 24)
--    intended to come before plug#begin, but lazy.nvim doesn't need that.
--    Without re-enabling, files don't get their filetype set, and treesitter
--    highlight + LSP attach never fire.
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")
