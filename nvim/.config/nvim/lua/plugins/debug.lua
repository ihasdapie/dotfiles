-- Debugger: nvim-dap + ui

return {
    {
        "mfussenegger/nvim-dap",
        cmd = { "DapToggleBreakpoint", "DapContinue", "DapStepOver",
                "DapStepInto", "DapStepOut", "DapTerminate", "DapNew" },
        keys = { "<F5>", "<F10>", "<F11>", "<F12>" },
        dependencies = {
            { "rcarriga/nvim-dap-ui",
              dependencies = "nvim-neotest/nvim-nio" },
        },
        -- pcall so a recursive/missing-dep error in dap_config doesn't abort
        -- the whole dap load; defer the require so dap-ui is fully loaded first
        config = function()
            vim.schedule(function()
                local ok, err = pcall(require, "dap_config")
                if not ok then
                    vim.notify("[nvim-fast-2] dap_config error: " .. tostring(err),
                        vim.log.levels.WARN)
                end
            end)
        end,
    },
}
