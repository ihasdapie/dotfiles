# nvim-fast-2

Brian's lazy.nvim-managed, Lua-first Neovim config. Loaded via `NVIM_APPNAME=nvim-fast-2` (use the `nvim-fast-2` shell wrapper).

Coexists with two older configs in `$HOME/.config/`:
- `nvim/` — original vim-plug config.
- `nvim-arm/` — vim-plug, ARM-host legacy. **nvim-fast-2 still pulls files from here** (see "Coexistence with nvim-arm" below); do not delete it.
- `nvim-fast/` — vim-plug + lazy patches, intermediate step before this rewrite.

## Quick orientation

| File | Role |
|------|------|
| `init.lua` | Bootstrap (vim.loader, deprecation filter, rtp pruning, lazy clone, lazy.setup, legacy bridges). Read this first. |
| `legacy.vim` | Slimmed-down vimscript carried from nvim-arm. Holds general `set` options, custom `:Rg` / `:RgHidden` commands, etc. Sourced from `init.lua` step 6. |
| `lazy-lock.json` | lazy.nvim plugin lockfile. Commit changes after `:Lazy update`. |
| `lua/plugins/*.lua` | Plugin specs grouped by domain (one return-table per file, imported via `{ import = "plugins" }`). |
| `lua/configs/*.lua` | Per-plugin `setup()` callbacks. Called from plugin specs as `config = function() require("configs.<name>") end`. |
| `coc-settings.json` | Symlink → `nvim-arm/coc-settings.json`. coc itself is gone, but some Mason/lspconfig consumers still read it. |
| `UltiSnips/` | Symlink → `nvim-arm/plugged/vim-snippets/UltiSnips`. UltiSnips scans every rtp entry for a `UltiSnips` child dir. |
| `undo/`, `view/`, `swap/` | Runtime state. Gitignored. |

## Plugin file layout

Each `lua/plugins/<domain>.lua` returns a list of lazy.nvim specs. Add new plugins to the file that matches their domain.

| File | What lives here |
|------|-----------------|
| `ai.lua` | github/copilot.vim, CopilotChat.nvim, coder/claudecode.nvim |
| `debug.lua` | mfussenegger/nvim-dap + rcarriga/nvim-dap-ui |
| `editor.lua` | which-key, autopairs, surround, repeat, Comment.nvim, marks.nvim, nvim-colorizer.lua, vim-visual-multi, nvim-bqf, flash.nvim, indent-blankline, vim-easy-align, bigfile.nvim |
| `extras.lua` | hydra.nvim, **toggleterm.nvim** (floating terminal), TrueZen, minimap, winshift, vim-maximizer, undotree, tabular, suda, AnsiEsc, vim-dispatch, spotdiff, vim-diffchanges, trouble.nvim, grug-far, open-browser, vim-bazel, leetcode, plenary, vim-startuptime |
| `files.lua` | neo-tree, nnn.vim, fzf + fzf.vim, telescope, zoxide |
| `git.lua` | gitsigns, vim-fugitive, gitlinker |
| `lang.lua` | nvim-treesitter (pinned `tag = "v0.10.0"`), aerial, vimtex, vim-pandoc, orgmode, neogen, nabla, venn, sniprun, vim-dadbod(+ui), md-img-paste, niche FT plugins |
| `lsp.lua` | mason, mason-lspconfig, nvim-lspconfig, LuaSnip + friendly-snippets, ultisnips, nvim-cmp + sources, conform.nvim, nvim-lint, lazydev, yanky |
| `ui.lua` | kanagawa (priority 1000) + alt colorschemes, nvim-web-devicons, galaxyline, tabby, **snacks.nvim** (priority 999, dashboard + everything), noice + nui + nvim-notify |

## Coexistence with nvim-arm

`init.lua` deliberately bridges to the older nvim-arm config rather than copying its lua/ files in:

1. **`package.path` prepend** (`init.lua:86-89`) — adds `~/.config/nvim-arm/lua/?.lua` so any `require("foo_config")` resolves to the legacy config module. Many plugin specs use this (e.g. `require("kanagawa_config")`, `require("galaxyline_config")`, `require("which-key_config")`, `require("hydra_config")`, `require("gitsigns_config")`, `require("dap_config")`, etc.).
2. **`vim.cmd.source(... keybindings.vim)`** (`init.lua:136`) — sources the legacy keybindings file directly.
3. **Symlinks**: `UltiSnips`, `coc-settings.json` point into `nvim-arm/`.

Consequence: editing nvim-arm/lua/*_config.lua **affects nvim-fast-2**. If you need a divergent setting, copy the function body into `lua/configs/<name>.lua` and switch the spec's `config = function() ... end` to `require("configs.<name>")`. See `lua/configs/legacy_aliases.lua` and `lua/configs/legacy_overrides.lua` for the patterns already used.

⚠️ **Do not** `vim.opt.rtp:append("~/.config/nvim-arm")`. lazy.nvim refuses to start with: *"Found paths on the rtp from another plugin manager `plugged`"* (nvim-arm contains `plugged/`). The `package.path` trick is the supported workaround.

## Conventions

- **Add a plugin**: drop `{ "owner/name", event = ..., config = function() require("configs.<name>") end }` into the right `lua/plugins/<domain>.lua`. Prefer lazy triggers (`event` / `cmd` / `keys` / `ft`) over `lazy = false`. Cold-start time is a feature here.
- **Non-trivial setup**: write it as `lua/configs/<name>.lua` and `require` it from the spec. Inline `config` only for one-liners.
- **Naming**: `lua/configs/<name>.lua` for files specific to nvim-fast-2; legacy `<name>_config.lua` modules live in nvim-arm/lua/ and are reached via `package.path`.
- **Disable a built-in plugin**: add to `rtp_disabled` in `init.lua:53`. List doubles as the lazy.nvim `performance.rtp.disabled_plugins` value.
- **Silence a deprecation**: add the symbol to the `_swallow` table in `init.lua:28`. If the symbol is gone in current nvim and a plugin still calls it, also install a shim in the same block (see the `vim.lsp.buf_get_clients` example).
- **Profile cold start**: `:StartupTime` (dstein64/vim-startuptime, declared in `extras.lua`). 5 runs by default; bump `vim.g.startuptime_tries` if you need tighter medians.

## Diagnostic UI policy (`lua/configs/lsp.lua`)

- **Inline virtual text is OFF.** `virtual_text = false` and `virtual_lines = false` in `vim.diagnostic.config`. Don't re-enable without asking — Brian dislikes diagnostics rendered into the buffer text.
- **Signs in the gutter are ON** with custom severity glyphs.
- **Jumps auto-pop the float and wrap around.** Global `jump = { wrap = true, on_jump = fn }` is set in `lsp.lua` — `on_jump` calls `vim.diagnostic.open_float({ scope = "cursor", focus = false, ... })`. Don't open a float manually after jumping. **Don't use the legacy `jump.float = true` shortcut** in nvim 0.12 — it's deprecated and (worse) replacing the `jump` table also wipes the default `wrap = true`, which was the actual bug behind "`[g`/`]g` doesn't work" — silent no-op once you were past the last diagnostic.
- **Cycle bindings use the modern API.** `[d`/`]d` (buffer-local, `lsp.lua` on_attach) and `[g`/`]g` (global, `legacy_overrides.lua`) all call `vim.diagnostic.jump({ count = ±1 })`. The deprecated `vim.diagnostic.goto_prev/goto_next` are gone — don't reintroduce them.
- **List for the buffer:** `:lua vim.diagnostic.setqflist({ bufnr = 0 })` (qflist) or `:lua vim.diagnostic.setloclist()` / `<leader>q` (loclist). For UI, `:Trouble diagnostics toggle filter.buf=0` uses trouble.nvim from `extras.lua`.

## nvim-cmp Tab semantics (`lua/configs/cmp.lua`)

- **`<Tab>` confirms with select.** When the menu is visible, `<Tab>` calls `cmp.confirm({ select = true })` — a single press accepts the top (or currently highlighted) suggestion. Don't change this back to `cmp.select_next_item()`.
- **Browsing uses `<C-n>`/`<C-p>`** from the cmp preset; `<C-CR>` is the explicit confirm. Snippet expand/jump still chains after the visibility branch (luasnip `expand_or_jumpable`).

## Cache and reloading

- **XDG paths are on /tmp NVMe**: `XDG_CACHE_HOME=/tmp/briachen/.cache`, `XDG_DATA_HOME=/tmp/briachen/share`. nvim's `stdpath("cache")` / `stdpath("data")` resolve under there. The cache dir is shared with nvim-arm (the appname suffix lands as `nvim-arm` in this user's setup, not `nvim-fast-2` — both configs hit the same bytecode/lazy cache).
- **`vim.loader` (init.lua:6) bytecode cache invalidates on mtime.** Edit a file, save it, next nvim start picks up the change. No manual `rm -rf` of the cache is ever needed for normal edits.
- **Lazy.nvim install/update cache** lives at `stdpath("data")/lazy/`. Use `:Lazy sync` / `:Lazy update` rather than nuking the dir.
- **Reload a single config without restart:**
  ```vim
  :lua package.loaded["configs.<name>"] = nil; require("configs.<name>")
  ```
  Caveat for `configs.lsp`: `vim.diagnostic.config` re-applies globally, but `on_attach` buffer-local maps (`[d`/`]d`, `gd`, etc.) only re-bind on the next LSP attach. Run `:LspRestart` or close/reopen the buffer to pick them up.
- **Restart wins for ambiguity.** If anything from `lua/plugins/*.lua` changed, `:qa` and relaunch — lazy.nvim's spec graph isn't safe to re-run mid-session.

## Floating terminal

`akinsho/toggleterm.nvim` (`extras.lua:13`, configured in `lua/configs/toggleterm.lua`). Replaces the old vim-floaterm. The config registers `:Floaterm*` user-command aliases (`FloatermToggle`, `FloatermNew`, `FloatermNext`, `FloatermPrev`, `FloatermKill`) so muscle memory and which-key bindings keep working.

## Things removed (don't add back without a reason)

| Removed | Replaced by |
|---------|-------------|
| coc.nvim, coc-* extensions | mason + nvim-lspconfig + nvim-cmp + conform + nvim-lint |
| vim-floaterm | toggleterm.nvim |
| vista.vim | aerial.nvim |
| kommentary | Comment.nvim |
| kshenoy/vim-signature | chentoast/marks.nvim |
| chrisbra/Colorizer | catgoose/nvim-colorizer.lua |
| gelguy/wilder.nvim | folke/noice.nvim |
| goolord/alpha-nvim | folke/snacks.nvim (`snacks.dashboard`) |
| lewis6991/impatient.nvim | built-in `vim.loader` |
| vim-scripts/LargeFile, LunarVim/bigfile.nvim | folke/snacks.nvim (`snacks.bigfile`) |
| famiu/bufdelete.nvim | folke/snacks.nvim (`snacks.bufdelete`) — `:Bdelete`/`:BWipeout` shims in `legacy_aliases.lua` |
| FixCursorHold.nvim | not needed on nvim ≥ 0.6 |

Eagerly cloning `vim-snippets/` as a separate plugin is also intentionally avoided (`editor.lua:81-84`); LuaSnip's snipmate loader and UltiSnips both read directly from `nvim-arm/plugged/vim-snippets/`.

## Source-of-truth and dotfiles

`~/.config/nvim-fast-2/` is **xstow-managed**: every config file inside it is a relative symlink into `~/dotfiles/nvim-fast-2/.config/nvim-fast-2/`. Edit either path — they're the same bytes — and `git -C ~/dotfiles status` will show the diff.

```text
~/.config/nvim-fast-2/
├── init.lua          → ../../dotfiles/nvim-fast-2/.config/nvim-fast-2/init.lua
├── legacy.vim        → ../../dotfiles/nvim-fast-2/.config/nvim-fast-2/legacy.vim
├── lazy-lock.json    → ../../dotfiles/nvim-fast-2/.config/nvim-fast-2/lazy-lock.json
├── lua               → ../../dotfiles/nvim-fast-2/.config/nvim-fast-2/lua    (whole subtree)
├── AGENTS.md         → ../../dotfiles/nvim-fast-2/.config/nvim-fast-2/AGENTS.md
├── MIGRATION_PLAN.md → ../../dotfiles/nvim-fast-2/.config/nvim-fast-2/MIGRATION_PLAN.md
├── UltiSnips         → … → nvim-arm/plugged/vim-snippets/UltiSnips  (chained)
├── coc-settings.json → … → nvim-arm/coc-settings.json                (chained)
├── .gitignore        → ../../dotfiles/nvim-fast-2/.config/nvim-fast-2/.gitignore
├── undo/             real dir (gitignored — runtime undo history)
├── view/             real dir (gitignored — runtime view state)
└── swap/             real dir (gitignored)
```

### Re-stowing

The xstow binary lives at `~/s14overlay/bin/xstow` (aarch64 build — the `~/.local/bin/xstow` you had was x86-64 and didn't run on this machine, so I rebuilt from `https://github.com/majorkingleo/xstow.git` and dropped the binary into `s14overlay`). Standard ops:

```sh
cd ~/dotfiles && ~/s14overlay/bin/xstow -t ~ nvim-fast-2          # install / refresh
cd ~/dotfiles && ~/s14overlay/bin/xstow -D -t ~ nvim-fast-2       # uninstall
cd ~/dotfiles && ~/s14overlay/bin/xstow -R -t ~ nvim-fast-2       # restow (D + install)
cd ~/dotfiles && ~/s14overlay/bin/xstow -c -t ~ nvim-fast-2       # dry-run conflict check
```

After unstow, the runtime dirs (`undo/`, `view/`, `swap/`) survive — xstow only touches what it owns. Re-stow puts the symlinks back alongside them.

### Don't put files at the package root

`~/dotfiles/nvim-fast-2/<file>` (one level above `.config/`) gets stowed into `~/<file>`, not `~/.config/nvim-fast-2/<file>`. The package's old root-level `.gitignore` got linked to `~/.gitignore` on first stow attempt; it's been moved to `~/dotfiles/nvim-fast-2/.config/nvim-fast-2/.gitignore` so it lands inside the config dir like the existing nvim package's gitignore does.

### Commit workflow

Edit anything under `~/.config/nvim-fast-2/`. `cd ~/dotfiles && git status nvim-fast-2/` shows the diff. Commit and push from the dotfiles repo as usual.

A backup of the pre-stow live config lives at `~/.config/nvim-fast-2.pre-stow.bak/` — delete it once you've used the stow setup for a session and confirmed nothing's missing (`rm -rf ~/.config/nvim-fast-2.pre-stow.bak`).
