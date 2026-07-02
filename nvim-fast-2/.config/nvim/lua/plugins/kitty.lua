-- kitty-scrollback.nvim — browse the kitty scrollback / last-command output in
-- nvim, with correct ANSI + OSC-8 (hyperlink) escaping. Replaces the old custom
-- minimal.vim + lua/kittypager.lua recipe (which re-emitted buffer lines through
-- a term channel and mangled special characters / OSC-8 sequences).
--
-- kitty side (configured in ~/.config/kitty/kitty.conf): a kitten launches nvim
-- with this config and fires `User KittyScrollbackLaunch`, which loads + sets up
-- the plugin. Requires `allow_remote_control yes` and `listen_on` (already set).
-- Run :KittyScrollbackCheckHealth to verify the kitty<->nvim wiring.

return {
    {
        "mikesmithgh/kitty-scrollback.nvim",
        lazy = true,
        -- Loaded on demand by the kitten (User event) or the generate/health
        -- commands; adds zero cold-start cost to normal nvim launches.
        cmd = {
            "KittyScrollbackGenerateKittens",
            "KittyScrollbackCheckHealth",
            "KittyScrollbackGenerateCommandLineEditing",
        },
        event = { "User KittyScrollbackLaunch" },
        config = function()
            require("kitty-scrollback").setup({
                -- The paste/command window draws a separate 1-row footer bar
                -- (the `:w Paste` / mappings hint) anchored just below it. When
                -- the window opens near the bottom of the screen that extra row
                -- doesn't fit, so kitty scrolls the whole screen up by 1 line.
                -- Hide the footer on open to reclaim that row; `g?` still
                -- toggles it back when you want the mappings reference.
                paste_window = {
                    hide_footer = true,
                },
            })

            -- The scrollback view is a `term://` buffer. While it's in terminal
            -- mode, <Esc> is forwarded to the terminal and does NOT drop you to
            -- normal mode (vim's terminal default needs <C-\><C-n>). That's why
            -- <Esc> "doesn't obviously" switch modes. Map it buffer-locally so
            -- <Esc> reliably lands you in normal mode for vim-style navigation
            -- (k/j/G/gg, / search, y to yank). The plugin still uses `q` /
            -- <C-c> to close the pager, and `i` opens the command/paste window.
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("ksb_esc_to_normal", { clear = true }),
                pattern = "kitty-scrollback",
                callback = function(ev)
                    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], {
                        buffer = ev.buf,
                        desc = "kitty-scrollback: terminal → normal mode",
                    })
                end,
            })
        end,
    },
}
