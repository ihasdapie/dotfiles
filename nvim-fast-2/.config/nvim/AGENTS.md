# nvim-fast-2

Brian's lazy.nvim-managed, Lua-first Neovim config. Loaded via `NVIM_APPNAME=nvim-fast-2` (use the `nvim-fast-2` shell wrapper).

Coexists with two older configs in `$HOME/.config/`:
- `nvim/` — original vim-plug config. The legacy `*_config.lua` modules under `lua/legacy/` were copied verbatim from here.
- `nvim-arm/` — vim-plug, ARM-host legacy. **No longer a dependency.** nvim-fast-2 used to pull its `*_config.lua` modules + `keybindings.vim` from `nvim-arm/lua` via `package.path`; that tree got wiped, so those files are now vendored into `lua/legacy/` (see "Vendored legacy modules" below). Safe to delete nvim-arm.
- `nvim-fast/` — vim-plug + lazy patches, intermediate step before this rewrite.

## Quick orientation

| File | Role |
|------|------|
| `init.lua` | Bootstrap (vim.loader, deprecation filter, rtp pruning, lazy clone, lazy.setup, legacy bridges). Read this first. |
| `legacy.vim` | Slimmed-down vimscript (originally from nvim-arm/init.vim). Holds general `set` options, custom `:Rg` / `:RgHidden` commands, persistent-undo/view dirs (self-contained under this config), etc. Sourced from `init.lua` step 6. |
| `keybindings.vim` | Legacy vimscript keymaps (j→gj, `*`/`#` search, etc.), vendored from the original config. Sourced from `init.lua` step 6; coc-era bindings in it are patched/neutralized by `lua/configs/legacy_overrides.lua`. |
| `lazy-lock.json` | lazy.nvim plugin lockfile. Commit changes after `:Lazy update`. |
| `lua/plugins/*.lua` | Plugin specs grouped by domain (one return-table per file, imported via `{ import = "plugins" }`). |
| `lua/configs/*.lua` | Per-plugin `setup()` callbacks specific to nvim-fast-2. Called from plugin specs as `config = function() require("configs.<name>") end`. |
| `lua/legacy/*.lua` | Vendored legacy `*_config.lua` modules (which-key, hydra, galaxyline, tabby, autopairs, indent-blankline, gitlinker, neogen, dap, kanagawa, claude, copilot_chat) + `functions.lua`. Required by bare name (`require("which-key_config")`) via a `package.path` entry set in `init.lua` step 3b. |
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
| `kitty.lua` | mikesmithgh/kitty-scrollback.nvim (the kitty scrollback / last-command pager) |
| `lang.lua` | nvim-treesitter (pinned `tag = "v0.10.0"`), aerial, vimtex, vim-pandoc, orgmode, neogen, nabla, venn, sniprun, vim-dadbod(+ui), md-img-paste, niche FT plugins |
| `lsp.lua` | mason, mason-lspconfig, nvim-lspconfig, LuaSnip + friendly-snippets, ultisnips, nvim-cmp + sources, conform.nvim, nvim-lint, lazydev, yanky |
| `ui.lua` | kanagawa (priority 1000) + alt colorschemes, nvim-web-devicons, galaxyline, tabby, **snacks.nvim** (priority 999, dashboard + everything), noice + nui + nvim-notify |

## Vendored legacy modules

The legacy `*_config.lua` modules and `keybindings.vim` were originally borrowed live from `~/.config/nvim-arm/` via `package.path` + a `vim.cmd.source`. That tree got wiped, so they're now **vendored self-contained** into this config (copied verbatim from the original vim-plug `~/.config/nvim/` source):

1. **`lua/legacy/*.lua`** — the legacy `*_config.lua` modules (`which-key_config`, `hydra_config`, `galaxyline_config`, `tabby_config`, `nvim-autopairs_config`, `indent-blankline_config`, `gitlinker_config`, `neogen_config`, `dap_config`, `kanagawa_config`, `copilot_chat_config`, `claude_config`) plus `functions.lua` and `utils/galaxyline_utils.lua`.
2. **`package.path` prepend** (`init.lua` step 3b) — adds `<config>/lua/legacy/?.lua` so the bare-name `require("which-key_config")` etc. calls in the plugin specs keep resolving without scattering these files across the top-level `lua/`.
3. **`keybindings.vim`** at the config root — sourced from `init.lua` step 6.

The plugin specs still `require("<name>_config")` by bare name; coc-era cruft inside `which-key_config.lua` / `keybindings.vim` is patched at runtime by `lua/configs/legacy_overrides.lua` (on `User VeryLazy`). `kanagawa_config` is `pcall`-wrapped in `ui.lua` and errors harmlessly (it calls `kanagawa.colors.setup()` before a kanagawa theme is active) — the active scheme is `kintsugi-flared`, so it's a tolerated no-op.

If you want a divergent setting for one of these, edit it in `lua/legacy/<name>.lua` directly (it's yours now), or promote it to `lua/configs/<name>.lua` and switch the spec to `require("configs.<name>")`.

⚠️ **Do not** add a foreign plugin-manager tree (e.g. `~/.config/nvim-arm`) to `rtp`. lazy.nvim refuses to start with: *"Found paths on the rtp from another plugin manager `plugged`"*. The `package.path` trick is the supported workaround for bare-name requires.

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

## Python provider (UltiSnips)

UltiSnips (and anything gated on `has('python3')`) needs nvim's python3 provider, i.e. `pynvim` importable from `g:python3_host_prog`. We keep a dedicated, **uv-managed nvim-only venv** so the system Python stays clean.

- **Location:** `stdpath("data")/venv` → `~/.local/share/nvim/venv` (holds only `pynvim`).
- **Wiring** (`init.lua` step 4): sets `vim.g.python3_host_prog` to that venv's `bin/python3` **iff it exists**; otherwise sets `vim.g.loaded_python3_provider = 0` so plugins fail soft (no `E319` spam) instead of erroring on a stale path.
- **Create / rebuild it:** `~/.config/nvim/scripts/setup-python-provider.sh` (idempotent; `--force` to rebuild from scratch). It installs `uv` if missing (Homebrew, else the official installer), provisions CPython 3.12, creates the venv, and `uv pip install`s `pynvim`. Run once per machine.
- **Verify:** `:checkhealth vim.provider`, or `:lua print(vim.fn.has('python3'))` should be `1`.
- The venv lives under `stdpath("data")`, outside the repo — not committed, rebuilt by the script.

## Kitty scrollback pager

`ctrl+shift+h` (scrollback) and `ctrl+shift+g` (last command's output) open in nvim via **mikesmithgh/kitty-scrollback.nvim** (`lua/plugins/kitty.lua`), which handles ANSI + OSC-8 (hyperlink) escaping correctly.

- **Replaced** the old custom recipe (`scrollback_pager nvim -u ~/.config/nvim/minimal.vim … require("kittypager")`). That broke when nvim-fast-2 took over `~/.config/nvim` (no `minimal.vim`/`kittypager` there) and mangled special chars regardless. Its lines are commented out in `kitty.conf`; `scrollback_pager` is back to the `less` default as a harmless fallback.
- **kitty side** (`~/.config/kitty/kitty.conf`, symlinked from `dotfiles/kitty`): `action_alias kitty_scrollback_nvim kitten ${HOME}/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py` + `map kitty_mod+h` / `map kitty_mod+g`. Relies on `allow_remote_control yes` + `listen_on` (already set).
- The kitten path points into nvim's lazy data dir — valid as long as the plugin is installed there (`:Lazy install`). On a host with a non-default `XDG_DATA_HOME`, update the path.
- **Verify:** open kitty, `ctrl+shift+h`; or run `:KittyScrollbackCheckHealth` inside a kitty-launched nvim. After editing kitty.conf, reload with `ctrl+shift+f5` (or `kitty @ load-config`).

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
├── init.lua          → ../../dotfiles/nvim-fast-2/.config/nvim/init.lua
├── legacy.vim        → ../../dotfiles/nvim-fast-2/.config/nvim/legacy.vim
├── keybindings.vim   → ../../dotfiles/nvim-fast-2/.config/nvim/keybindings.vim
├── lazy-lock.json    → ../../dotfiles/nvim-fast-2/.config/nvim/lazy-lock.json
├── lua               (real dir; per-file symlinks under configs/ + plugins/, lua/legacy → package subtree)
├── AGENTS.md         → ../../dotfiles/nvim-fast-2/.config/nvim/AGENTS.md
├── MIGRATION_PLAN.md → ../../dotfiles/nvim-fast-2/.config/nvim/MIGRATION_PLAN.md
├── .gitignore        → ../../dotfiles/nvim-fast-2/.config/nvim/.gitignore
├── undo/             real dir (gitignored — runtime undo history)
├── view/             real dir (gitignored — runtime view state)
└── swap/             real dir (gitignored)
```

> Note: on this Mac the package is stowed as plain `~/.config/nvim/` (not `nvim-fast-2/`)
> using GNU `stow` (`cd ~/dotfiles && stow -R -t ~ nvim-fast-2`). The `~/s14overlay/bin/xstow`
> instructions below are from the original ARM host; `stow` is the equivalent here. After adding
> a new file to the package, re-run the stow command so it gets symlinked into the live config.

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
