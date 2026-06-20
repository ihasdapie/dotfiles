-- AI integrations: copilot, claudecode, copilot-chat
-- coc.nvim removed — replaced by native LSP stack (lua/plugins/lsp.lua)

return {
    -- GitHub Copilot — preload after UI paint (was InsertEnter, but the
    -- Node child-process spawn took 100-300ms and dominated first-insert
    -- lag). VeryLazy fires ~50ms post-VimEnter; Copilot finishes its
    -- handshake while the user is still orienting in the buffer.
    --
    -- copilot.vim's plugin/copilot.vim registers a BufEnter,InsertEnter
    -- autocmd that defers the actual Node agent spawn until first event
    -- fires. Loading the plugin at VeryLazy isn't enough — we have to
    -- explicitly kick the agent so the spawn happens in the background.
    -- 100ms defer gives the autoload functions time to be sourced.
    {
        "github/copilot.vim",
        event = "VeryLazy",
        config = function()
            vim.defer_fn(function()
                pcall(vim.fn["copilot#Schedule"])
            end, 100)
        end,
    },

    -- Copilot Chat
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle",
                "CopilotChatReset", "CopilotChatModels" },
        dependencies = { "nvim-lua/plenary.nvim", "github/copilot.vim" },
        config = function() require("copilot_chat_config") end,
    },

    -- ClaudeCode
    {
        "coder/claudecode.nvim",
        cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeStart", "ClaudeCodeStop",
                "ClaudeCodeStatus", "ClaudeCodeSend", "ClaudeCodeTreeAdd" },
        dependencies = { "nvim-lua/plenary.nvim" },  -- snacks dropped
        config = function() require("claude_config") end,
    },
}
