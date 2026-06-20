-- nvim-lint — linting (sparingly; LSP covers most diagnostics)

local lint = require("lint")

lint.linters_by_ft = {
    python = { "ruff" },
    sh     = { "shellcheck" },
    -- markdown   = { "markdownlint" },
    -- dockerfile = { "hadolint" },
}

-- Only run linters whose binary is actually on $PATH. Without this guard,
-- saving an sh file when shellcheck isn't installed surfaces
-- `running shellcheck: ENOENT: no such file or directory` from
-- vim.fn.jobstart on every save. Same goes for ruff on py files etc.
-- Cache the result so we don't fork-stat every BufWritePost.
local _bin_cache = {}
local function bin_exists(name)
    local cached = _bin_cache[name]
    if cached ~= nil then return cached end
    local linter_def = lint.linters[name]
    local cmd_name = name
    if type(linter_def) == "table" and linter_def.cmd then
        cmd_name = type(linter_def.cmd) == "function" and linter_def.cmd() or linter_def.cmd
    end
    local ok = vim.fn.executable(cmd_name) == 1
    _bin_cache[name] = ok
    return ok
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = function()
        local ft = vim.bo.filetype
        local linters = lint.linters_by_ft[ft]
        if not linters or #linters == 0 then return end
        local available = {}
        for _, name in ipairs(linters) do
            if bin_exists(name) then table.insert(available, name) end
        end
        if #available > 0 then lint.try_lint(available) end
    end,
})
