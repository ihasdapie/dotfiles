# nvim-fast-2 — Legacy Compat Wrapper Migration Plan

**Goal:** detach `nvim-fast-2` from the `nvim-arm` config it currently piggybacks on, replace every shim/alias with a native call, and emit a user-facing migration guide so muscle-memory rebinds are explicit.

**Non-goal:** breaking `nvim-arm`. After this work, `nvim-arm` is untouched and `nvim-fast-2` is fully self-contained.

---

## 0. Inventory of the legacy compat surface

The bridge that has to come down is roughly 1,150 lines, spread across these touchpoints (file → role):

| File | Lines | Role |
|------|------:|------|
| `init.lua` (steps 6, 7, 7b, 3b) | ~25 | Sources `legacy.vim`, sources `nvim-arm/keybindings.vim`, prepends `nvim-arm/lua/?.lua` to `package.path`, requires `legacy_aliases` + `legacy_overrides`. |
| `legacy.vim` | 346 | Vimscript carried verbatim from `nvim-arm/init.vim`: `set` options, `Rg`/`RG`/`RgWordUnderCursor`/`RgHidden`/`E`/`Delview`/`Open`/`Scratch`, vimtex/pandoc/suda/csv lets. |
| `lua/configs/legacy_aliases.lua` | 163 | Defines user commands that mimic gone plugins: `PlugInstall`, `Reload`, `Whichkey`, `CocRestart`, `CocRebuild`, `CocConfig`, `CocSearch`, `CocList`, `CocCommand`, `CocYank`, `CocSettings`, `FzfSwitchProject`, `DashboardNewFile`, `IndentBlanklineToggle`, `TSBufToggle`, `TSContextToggle`, `Pickachu`, `Pick`, `GoFillStruct`/`GoCallers`/`GoTest`, `LuaSnipEdit`. |
| `lua/configs/legacy_overrides.lua` | 215 | Patches keymaps that came from `nvim-arm/keybindings.vim`: deletes/restores `<C-f>`/`<C-b>`, swaps `[g`/`]g` and `<leader>c*` from coc-Plug to native LSP, strips coc-Plug entries from which-key's registry, defines `VisualSelection()`, ports vimtex which-key, rebinds `<localleader>` to lazy-load which-key. |
| `nvim-arm/keybindings.vim` (sourced) | 101 | Misc `nnoremap`s: `<leader>sR :CocSearch`, `<C-j> Plug(coc-snippets-…)`, `<C-f>`/`<C-b>` coc#float#scroll, `<localleader>x/z` neotest, etc. |
| `nvim-arm/lua/which-key_config.lua` (required) | 327 | The full which-key registry. Hard-codes coc/Plug/Floaterm/Vista/Pickachu/Duck/CocSearch/etc. |
| `nvim-arm/lua/<name>_config.lua` (required) | varies | Per-plugin config callbacks reached via `package.path`: `gitsigns_config`, `gitlinker_config`, `copilot_chat_config`, `claude_config`, `hydra_config`, `galaxyline_config`, `tabby_config`, `neogen_config`, `kanagawa_config`, `nvim-autopairs_config`, `indent-blankline_config`, `dap_config`, plus `vimtex_bindings`, `tmp_init`, `functions`, `utils/`. |
| `~/.config/nvim-fast-2/UltiSnips`, `coc-settings.json` | — | Symlinks into `nvim-arm/`. |

The plan below brings each touchpoint to ground in **eight phases**, each independently runnable (config still loads at the end of every phase).

---

## Phase 1 — Fork the shared sources into nvim-fast-2

**Why first:** decouple the two configs at the file level so subsequent edits never leak into nvim-arm.

**Steps**

1. Copy keybindings into local ownership:
   ```sh
   cp ~/.config/nvim-arm/keybindings.vim       ~/.config/nvim-fast-2/keybindings.vim
   cp ~/.config/nvim-arm/lua/which-key_config.lua \
      ~/.config/nvim-fast-2/lua/configs/which-key.lua
   ```
2. Copy each `<name>_config.lua` consumed by `lua/plugins/*.lua` into `lua/configs/`:
   ```
   gitsigns_config        → lua/configs/gitsigns.lua
   gitlinker_config       → lua/configs/gitlinker.lua
   copilot_chat_config    → lua/configs/copilot_chat.lua
   claude_config          → lua/configs/claude.lua
   hydra_config           → lua/configs/hydra.lua
   galaxyline_config      → lua/configs/galaxyline.lua
   tabby_config           → lua/configs/tabby.lua
   neogen_config          → lua/configs/neogen.lua
   kanagawa_config        → lua/configs/kanagawa.lua
   nvim-autopairs_config  → lua/configs/autopairs.lua
   indent-blankline_config→ lua/configs/indent_blankline.lua
   dap_config             → lua/configs/dap.lua
   ```
   Plus the supporting helpers actually called from those files: `functions.lua`, `utils/*`, `tmp_init.lua` (only the bits not already inlined in `init.lua` step 5).
3. Update every `lua/plugins/*.lua` spec to point at the new module names (`require("configs.gitsigns")`, etc.). One-grep, one-edit:
   ```sh
   sed -i 's|require("\([a-z_-]*\)_config")|require("configs.\1")|g' \
       ~/.config/nvim-fast-2/lua/plugins/*.lua
   ```
   Then hand-fix the kebab-case ones (`indent-blankline_config`, `nvim-autopairs_config`) to match the new file names.
4. In `init.lua`:
   - Replace `vim.cmd.source(... "/nvim-arm/keybindings.vim")` (line 136) with `vim.cmd.source(... stdpath("config") .. "/keybindings.vim")`.
   - Add `require("configs.which-key")` near the existing `legacy_aliases` require (it was implicitly loaded via the `which-key` plugin's config callback in nvim-arm; we now own the registry).
   - Keep the `package.path` prepend FOR NOW — it's still used by nvim-arm/lua/utils/ helpers some configs reach for. Removed in Phase 7.

**Acceptance:** `:checkhealth` passes; `nvim --startuptime /tmp/st.txt +qa && grep -c nvim-arm /tmp/st.txt` shows nvim-arm is no longer on the rtp/source path (only `package.path` references remain).

**Rollback:** `git checkout init.lua` and delete the copies. Two-command undo.

---

## Phase 2 — Replace shim commands with native commands in `which-key.lua`

**Goal:** edit only `~/.config/nvim-fast-2/lua/configs/which-key.lua` (and `keybindings.vim`) so they call the real commands directly. Once done, `legacy_aliases.lua` has no callers and becomes deletable.

**Translation table** (apply in `lua/configs/which-key.lua`):

| Old binding RHS | New binding RHS | Notes |
|-----------------|-----------------|-------|
| `<Plug>(coc-diagnostic-prev/next)` (`[g`/`]g`) | `<cmd>lua vim.diagnostic.goto_prev/goto_next()<CR>` | Or use nvim 0.11 built-in `[d`/`]d` and drop `[g`/`]g`. |
| `<Plug>(coc-definition/type-definition/implementation/references)` (`gd/gy/gI/gr`) | DELETE these `wk.add` rows. Buffer-local LSP defaults from `lua/configs/lsp.lua`'s `on_attach` already handle them, and nvim 0.11 ships `grr/gri/grt/grn/gra` built-ins. |
| `<Plug>(coc-codeaction*)` family (`<leader>cA/cL/ca/cR/cf/cl/cr`) | `<cmd>lua vim.lsp.buf.code_action()<CR>`, `vim.lsp.codelens.run()`, `vim.lsp.buf.rename()` etc. | Move the bodies from `legacy_overrides.lua:62-83` into the registry directly. |
| `<cmd>call ShowDocFloat()<CR>` (`<leader>ci`) | `<cmd>lua vim.lsp.buf.hover()<CR>` | |
| `<cmd>CocList --ignore-case commands<CR>` (`<leader>cc`) | `<cmd>Telescope commands<CR>` | |
| `<cmd>CocCommand clangd.switchSourceHeader<CR>` (`<leader>cs`) | Inline the `clangd:request("textDocument/switchSourceHeader", …)` lambda from `legacy_overrides.lua:73-83`. | |
| `<cmd>CocRestart<CR>` (`<leader>cmr`) | `<cmd>LspRestart<CR>` | |
| `<cmd>CocRebuild<CR>` (`<leader>cmR`) | `<cmd>Mason<CR>` | |
| `<cmd>GoFillStruct/GoCallers/CocCommand go.test.toggle<CR>` (`<leader>cgf/cgc/cgt`) | DELETE (vim-go not installed; use `<leader>ca` + gopls quickfix + `:!go test`). | |
| `<cmd>Pickachu …<CR>` (`<leader>cph/cpf/cpd`) | DELETE the rows. Color picker → none; file → `<cmd>Telescope find_files<CR>`; date → none. | |
| `<cmd>DashboardNewFile<CR>` (`<leader>fn`) | `<cmd>enew \| startinsert<CR>` | |
| `<cmd>Files ~/.config/nvim/<CR>` (`<leader>fP`) | `<cmd>Files ~/.config/nvim-fast-2/<CR>` | |
| `<cmd>PlugInstall/PlugClean/PlugUpdate<CR>` (`<leader>hpi/hpc/hpu`) | `<cmd>Lazy install<CR>`, `<cmd>Lazy clean<CR>`, `<cmd>Lazy update<CR>` | |
| `<cmd>Reload<CR>` (`<leader>hrr`) | `<cmd>source $MYVIMRC<CR>` | |
| `<cmd>Whichkey<CR>` (`<leader>hrb`, `<leader><leader>`) | `<cmd>WhichKey<CR>` | Casing-only fix. |
| `<cmd>CocList -A --normal yank<CR>` (`<leader>ly`) | `<cmd>YankyRingHistory<CR>` | |
| `<cmd>CocList -A outline/symbols<CR>` (`<leader>lo`/`<leader>ls`) | `<cmd>Telescope lsp_document_symbols<CR>` / `<cmd>Telescope lsp_workspace_symbols<CR>` | |
| `<cmd>CocList -A diagnostics<CR>` (`<leader>ld`) | `<cmd>Telescope diagnostics<CR>` | |
| `<cmd>FzfChooseProjectFile/FzfSwitchProject<CR>` (`<leader>pc/pp`) | `<cmd>Telescope find_files<CR>` (or wire up [`telescope-project.nvim`](https://github.com/nvim-telescope/telescope-project.nvim) if you want real switching). | |
| `<cmd>Vista finder<CR>` (`<leader>ss`) | `<cmd>AerialNavToggle<CR>` | |
| `:CocSearch ` (`<leader>sR`, `<leader>sr`) | `:Telescope live_grep<CR>` (interactive) or `:GrugFar<CR>` (replace). | |
| `<cmd>FloatermToggle<CR>` (`<leader>tt`, `<localleader>tt`) | `<cmd>ToggleTerm<CR>` | |
| `<cmd>FloatermNew<CR>` (`<leader>ot`, `<localleader>tn`) | `<cmd>ToggleTerm<CR>` (count++ via the toggleterm count prefix, e.g. `2<leader>tt`). | |
| `<cmd>FloatermNext/Prev<CR>` (`<localleader>tl/th`) | `<cmd>ToggleTerm<CR>` — toggleterm's "next" idea is the count-prefix model; bind to `<cmd>execute v:count1 . "ToggleTerm direction=float"<cr>` if you want the same affordance. | |
| `<cmd>FloatermKill<CR>` (`<localleader>tq/tc/td`) | `<cmd>TermExec cmd=exit<cr>` or just close the window. **NEW**: `<localleader>td` is freed up; reassign to `<cmd>DrawerToggle<CR>` for symmetry with `<leader>tD`. | |
| `<cmd>Vista!!<CR>` (`<leader>tv`) | `<cmd>AerialToggle<CR>` | |
| `<cmd>TSContextToggle<CR>` (`<leader>tTc`) | DELETE row (treesitter-context not installed) or add `nvim-treesitter/nvim-treesitter-context` to `lang.lua` first. | |
| `<cmd>TSBufToggle highlight<CR>` (`<leader>tTh`) | `<cmd>TSToggle highlight<CR>` | |
| `<cmd>IndentBlanklineToggle<CR>` (`<leader>ti`) | `<cmd>IBLToggle<CR>` | |
| `<cmd>NnnExplorer<CR>` (`<leader>te`) | Either keep (nnn.vim is in `files.lua`) or `<cmd>Neotree toggle left<CR>`. | |
| duck.nvim (`<leader>md/mD`) | DELETE rows. | |
| `<cmd>CocCommand explorer<CR>` (`<leader>op`) | `<cmd>Neotree toggle left<CR>` | |
| `<cmd>call CocAction(... 'reveal:0' ...)<CR>` (`<leader>of`) | `<cmd>Neotree reveal left<CR>` | |
| Insert: `<cmd>call CocActionAsync('showSignatureHelp')<CR>` (`<C-x>s`) | `<cmd>lua vim.lsp.buf.signature_help()<CR>` | |

**Same-key, also-edit:** `<leader>cd "<cmd>lua require('neogen').generate()<CR>"` — keep, neogen is installed.

**Acceptance:** `grep -nE 'Coc|Plug\\(|Floaterm|Pickachu|Vista|TSBufToggle|TSContextToggle|GoFillStruct|GoCallers|DashboardNewFile|IndentBlanklineToggle|FzfSwitchProject|FzfChooseProjectFile' ~/.config/nvim-fast-2/lua/configs/which-key.lua` returns nothing.

---

## Phase 3 — De-coc `keybindings.vim`

Edit `~/.config/nvim-fast-2/keybindings.vim` (the local copy from Phase 1):

1. Line 9 — `nnoremap <leader>sR :CocSearch` → delete (covered by `<leader>sR` in which-key).
2. Line 19 — `imap <C-j> <Plug>(coc-snippets-expand-jump)` → replace with LuaSnip jump:
   ```vim
   imap <silent><expr> <C-j> luaeval("require('luasnip').expandable() and '<Plug>luasnip-expand-or-jump' or '<C-j>'")
   smap <silent><expr> <C-j> luaeval("require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<C-j>'")
   ```
3. Lines 68–73 — `coc#float#has_scroll() ? coc#float#scroll(...)` for `<C-f>`/`<C-b>` → drop (let vim defaults stand). The deletion+restore loop in `legacy_overrides.lua:18-27` becomes unnecessary.
4. Lines 96–97 — `<localleader>x/z` neotest calls → keep only if neotest is installed; otherwise delete.

**Acceptance:** `grep -niE 'coc|plug\\(|cocsearch' ~/.config/nvim-fast-2/keybindings.vim` returns nothing.

---

## Phase 4 — Move plugin-config bodies into `lua/configs/`

The copies from Phase 1 live in `lua/configs/`. Audit each for nvim-arm-only assumptions and tighten to nvim-fast-2 reality:

| File | Things to fix |
|------|---------------|
| `lua/configs/which-key.lua` | The Phase 2 edits land here. Also strip the `<Plug>(coc-…)` rows entirely instead of leaving them disabled. |
| `lua/configs/galaxyline.lua` | Galaxyline calls into `vim.lsp.buf_get_clients()` (deprecated). The shim in `init.lua:38` lets it work today; either rewrite the section providers to call `vim.lsp.get_clients()` or keep the shim and remove the `_swallow` entry afterwards. |
| `lua/configs/gitsigns.lua` | No coc/plug references expected; verify. |
| `lua/configs/gitlinker.lua` | Verify `<leader>gy` mappings line up with which-key entries. |
| `lua/configs/copilot_chat.lua` | Probably references `snacks.nvim` if the nvim-arm copy was newer than expected — drop. |
| `lua/configs/claude.lua` | `coder/claudecode.nvim` setup. Make sure the `dependencies = { "snacks.nvim" }` (if present in nvim-arm copy) is removed; nvim-fast-2 doesn't ship snacks. |
| `lua/configs/hydra.lua` | Hydra triggers `vim.validate` deprecation; that warning is silenced by `init.lua:31`. After hydra.nvim upstream fixes, remove the `_swallow` entry. |
| `lua/configs/dap.lua` | Wrap require in `pcall` (already done in spec); verify dap-ui adapter setup. |
| `lua/configs/neogen.lua` | Verify the snippet engine setting matches nvim-fast-2 (LuaSnip, not coc-snippets). |
| `lua/configs/kanagawa.lua` | The plugin spec at `ui.lua:9-17` already calls `vim.cmd.colorscheme("kanagawa")` itself — local copy can just be the `setup({ ... })` body, no `colorscheme` call. |
| `lua/configs/autopairs.lua` | Verify nvim-cmp integration is wired (`require("nvim-autopairs.completion.cmp").on_confirm_done()` etc. — probably already present from the nvim-arm copy). |
| `lua/configs/indent_blankline.lua` | Update to ibl v3 API if the nvim-arm copy still uses v2. |
| `lua/configs/tabby.lua` | Verify icons resolve via nvim-web-devicons (no coc-explorer references). |

**Acceptance:** `grep -RnE 'coc|CocAction|CocCommand|<Plug>\\(coc' ~/.config/nvim-fast-2/lua/configs/` returns nothing.

---

## Phase 5 — Fold `legacy.vim` into Lua (or kill it)

Section-by-section disposition of the 346 vimscript lines:

| `legacy.vim` lines | Disposition |
|--------------------|-------------|
| 18–71  (general `set` options, mouse, sessionoptions, …) | Move to `lua/options.lua` (new), `require("options")` from `init.lua` step 5 (replacing the inlined block). |
| 72–86  (persistent undo dir setup) | Same — `lua/options.lua`. |
| 87–91  (source private user file) | `lua/options.lua` end. |
| 93–106 (`MyDeleteView` + `:Delview`) | `lua/configs/commands.lua`. |
| 108–114 (return-to-last-edit, quickfix nonlisted) | `lua/autocmds.lua`. |
| 117–169 (pandoc, hex-edit, asm, polyglot, omnifunc, n/N reverses) | Mix: `lua/options.lua` for lets, `lua/autocmds.lua` for FileType. |
| 188–190 (dead colorscheme let) | DELETE. |
| 194–217 (Rg/RG/RgWordUnderCursor/RgHidden + `RipgrepFzf`) | `lua/configs/fzf_commands.lua` — keep as vimscript heredoc OR rewrite as `vim.api.nvim_create_user_command` calling fzf-lua. |
| 219–231 (`s:MKDir` + `:E`) | `lua/configs/commands.lua`. |
| 233–263 (`Toggle_transparent`, `Scratch`, `MyLatexPasteImage`) | `lua/configs/commands.lua`. Drop `Scratch`/`Toggle_transparent` if unused (grep shows zero callers in keybindings/which-key — they're CLI-invoked). |
| 264–272 (md-img-paste settings) | Move into the md-img-paste spec's `init` callback in `lua/plugins/lang.lua`. |
| 274–305 (vimtex/suda/csv lets) | Move to each respective spec's `init` callback. |
| 316–end (`Open` xdg-open command) | `lua/configs/commands.lua`. |

After this, `legacy.vim` is empty and gets deleted. Step 6 of `init.lua` becomes `require("options")`.

**Acceptance:** `legacy.vim` deleted; `nvim --headless +qa` succeeds.

---

## Phase 6 — Drop `legacy_aliases.lua` and `legacy_overrides.lua`

By this point every binding in `which-key.lua` and every line in `keybindings.vim` calls the native command directly. Verify and delete:

1. Delete `lua/configs/legacy_aliases.lua`. Remove the `require("configs.legacy_aliases")` line from `init.lua` step 7.
2. Walk `lua/configs/legacy_overrides.lua` top-to-bottom and confirm each block is now redundant:
   - Block 1 (`<C-f>`/`<C-b>` delete+restore) — redundant once Phase 3 strips the coc#float#scroll lines from `keybindings.vim`.
   - Block 2 (replace coc-Plug → native LSP) — redundant once Phase 2 lands those bindings directly in `which-key.lua`.
   - Block 3 (`VisualSelection()` definition) — KEEP, but move into `lua/configs/commands.lua`. The `*`/`#` mappings in `keybindings.vim` rely on it.
   - Block 4 (vimtex which-key on FileType tex) — KEEP, but move into `lua/configs/vimtex.lua` and load via the vimtex spec's `config` callback.
   - Block 5 (`<localleader>` lazy-load which-key) — KEEP, but move into `lua/configs/which-key.lua` (top of file, after `wk.setup`).
3. Delete `lua/configs/legacy_overrides.lua`. Remove the `User VeryLazy` autocmd from `init.lua:148-152`.

**Acceptance:** `init.lua` no longer requires anything named `legacy_*`; `:lua print(vim.inspect(vim.fn.argv()))` works in nvim-fast-2.

---

## Phase 7 — Cut the `package.path` umbilical

The prepend at `init.lua:86-89` exists only so `require("xxx_config")` resolves. After Phase 4, every plugin spec uses `require("configs.<name>")` and the legacy modules in `nvim-arm/lua/` are unreferenced. Verify:

```sh
grep -RnoE 'require\(["'\'']([a-z_-]+)["'\'']\)' ~/.config/nvim-fast-2/ \
  | grep -v 'configs\.\|lazy\|telescope\.\|^.*//$' \
  | sort -u
```

Anything in the output that is NOT a stdlib/plugin module is a residual nvim-arm dependency. Move/inline it. When the list is clean, delete `init.lua:86-89`.

**Acceptance:** `nvim --headless +qa` and `:checkhealth` both pass with `init.lua:86-89` removed.

---

## Phase 8 — Symlinks and final cleanup

1. **`coc-settings.json`**: coc is gone — delete the symlink. If you want to keep an LSP-settings JSON, replace with a real file owned by nvim-fast-2 and rename to something LSP-meaningful (or drop entirely; mason's `:LspInstall` config already lives in `lua/configs/lsp.lua`).
2. **`UltiSnips/`**: keep the symlink (snippets are still useful) OR mirror the directory into `~/.config/nvim-fast-2/UltiSnips/` so the config is fully self-contained. Recommend keeping the symlink — `vim-snippets` is upstream-maintained, no reason to vendor a copy.
3. **AGENTS.md update**: change the "Coexistence with nvim-arm" section to reflect "nvim-fast-2 is now standalone; nvim-arm is a sibling but not a dependency." Drop the warning about not appending nvim-arm to rtp (no longer relevant).
4. **Dotfiles sync** — once stable, mirror to `~/dotfiles/nvim-fast-2/.config/nvim-fast-2/` (rsync command in `AGENTS.md`) and commit.

**Acceptance:** `ls -la ~/.config/nvim-fast-2/ | grep nvim-arm` returns nothing.

---

## Phase 9 — Migration guide for the user

A user-facing reference that lives at `~/.config/nvim-fast-2/MIGRATION_GUIDE.md`. Auto-generated from the Phase 2 translation table, plus three appendices:

### A. Same key, different command

| Key | Was | Now |
|-----|-----|-----|
| `<leader>tt` | FloatermToggle (vim-floaterm) | ToggleTerm (toggleterm.nvim, floating) |
| `<leader>tD` | — | DrawerToggle (toggleterm.nvim, bottom drawer) — **NEW** |
| `<leader>ti` | IndentBlanklineToggle (ibl v2) | IBLToggle (ibl v3) |
| `<leader>tv` | `Vista!!` | AerialToggle |
| `<leader>ss` | `Vista finder` | AerialNavToggle |
| `<leader>cmr` | CocRestart | LspRestart |
| `<leader>cmR` | CocRebuild | Mason |
| `<leader>hpi/hpc/hpu` | PlugInstall/Clean/Update | Lazy install/clean/update |
| `<leader>op` | CocCommand explorer | Neotree toggle left |
| `<leader>of` | CocAction explorer reveal | Neotree reveal left |
| `<leader>ly` | CocList yank | YankyRingHistory |
| `<leader>lo`/`ls` | CocList outline/symbols | Telescope lsp_document_symbols / lsp_workspace_symbols |
| `<leader>ld` | CocList diagnostics | Telescope diagnostics |
| `<leader>sR`/`<leader>sr` | CocSearch | Telescope live_grep |
| `<leader>cA/cL/ca/ci/cl/cr/cs` | coc-Plug code actions / hover / rename | vim.lsp.buf.* |
| `[g` / `]g` | coc-diagnostic-prev/next | vim.diagnostic.goto_prev/goto_next |
| `gd/gy/gI/gr` | coc-Plug | nvim 0.11 LSP defaults (`grr/gri/grt`) — buffer-local `gd` set in `configs/lsp.lua` |
| `<C-x>s` (insert) | CocActionAsync('showSignatureHelp') | vim.lsp.buf.signature_help |
| `<C-j>` (insert) | coc-snippets-expand-jump | LuaSnip expand_or_jump |
| `<localleader>td` | FloatermKill (3rd alias) | DrawerToggle (was redundant; reassigned) |

### B. Removed bindings

| Key | Was | Why |
|-----|-----|-----|
| `<leader>md` / `<leader>mD` | duck.nvim | Plugin not installed; stub removed. |
| `<leader>cph` / `<leader>cpf` / `<leader>cpd` | Pickachu | Plugin not installed (Tk-based, doesn't fit the lua-first config). Use `<cmd>Telescope find_files<CR>` etc. |
| `<leader>cgf` / `<leader>cgc` / `<leader>cgt` | vim-go / coc-go | vim-go not installed. Use `<leader>ca` (gopls quickfix) and `:!go test`. |
| `<leader>tTc` | TSContextToggle | treesitter-context plugin not installed. Add it to `plugins/lang.lua` if you want it back. |

### C. Newly available (nvim 0.11 built-ins, no longer shadowed)

| Key | Action |
|-----|--------|
| `grr` | LSP references |
| `grn` | LSP rename |
| `gra` | LSP code action |
| `gri` | LSP implementation |
| `grt` | LSP type definition |
| `[d` / `]d` | Diagnostic prev/next (built-in equivalent of `[g`/`]g`) |

These are the LSP defaults shipped in nvim 0.11. The Phase 2 deletion of the global `gd/gy/gI/gr` rows means they're no longer overridden, so the built-ins fire without a 420 ms which-key delay.

---

## Sequencing & risk

| Phase | Effort | Risk | Reversibility |
|------:|-------|------|---------------|
| 1 | 30 min | Low — pure copy + redirect. | `git revert` cleanly. |
| 2 | 2–3 hr | Medium — touches every leader binding. | Per-line; test live. |
| 3 | 30 min | Low. | Per-line. |
| 4 | 1–2 hr | Medium — config callbacks may have hidden dependencies. | Per-file. |
| 5 | 1–2 hr | Medium — vimscript→lua porting bugs. | Keep `legacy.vim` until Phase 5 acceptance passes; delete only after `:source $MYVIMRC` is clean. |
| 6 | 30 min | Low. | Restore the two files from git if wrong. |
| 7 | 15 min | Low. | One-line revert. |
| 8 | 15 min | Trivial. | — |
| 9 | 30 min (mostly mechanical) | Trivial. | — |

**Total:** roughly half a day of focused work. Each phase ends with the config still loadable, so the migration can be paused at any phase boundary.

## Done-criteria for the whole migration

- `grep -REn 'coc|CocAction|CocCommand|FloatermToggle|FloatermNew|FloatermNext|FloatermPrev|FloatermKill|PlugInstall|PlugClean|PlugUpdate|Pickachu|Vista|GoFillStruct|GoCallers|TSBufToggle|TSContextToggle|IndentBlanklineToggle|DashboardNewFile|FzfSwitchProject|FzfChooseProjectFile|Reload|Whichkey' ~/.config/nvim-fast-2/` returns nothing OUTSIDE comment blocks.
- `grep -RE 'nvim-arm' ~/.config/nvim-fast-2/init.lua ~/.config/nvim-fast-2/lua/` returns nothing.
- `nvim --headless +'lua print("ok")' +qa` exits clean.
- `MIGRATION_GUIDE.md` exists and accurately describes every key change.
- `~/dotfiles/nvim-fast-2/.config/nvim-fast-2/` is rsync'd to match the live copy and committed.
