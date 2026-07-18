-- LSP setup using nvim 0.11+ native vim.lsp.config / vim.lsp.enable.
-- No more `require('lspconfig')` framework calls (deprecated).

local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)

-- Disable LSP semantic-token highlighting per-server. Treesitter already
-- provides equivalent highlighting and is faster + incremental. Semantic
-- tokens trigger a full server round-trip on every text change in large
-- buffers — measurable typing-latency cost. Re-enable per-buffer with
-- `:lua vim.lsp.semantic_tokens.start(0, <client_id>)` if you want it.
local function disable_semantic_tokens(client)
    if client and client.server_capabilities then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

-- Buffer-local keymaps when an LSP attaches
local on_attach = function(client, bufnr)
    disable_semantic_tokens(client)
    local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
    end

    map("n", "gd", vim.lsp.buf.definition,        "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration,       "Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation,    "Go to implementation")
    map("n", "gr", vim.lsp.buf.references,        "References")
    map("n", "gy", vim.lsp.buf.type_definition,   "Type definition")
    map("n", "K",     vim.lsp.buf.hover,          "Hover docs")
    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
    map("n", "<leader>rn", vim.lsp.buf.rename,    "Rename symbol")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map({ "n", "v" }, "<leader>cF", function()
        require("conform").format({ async = false, lsp_fallback = true })
    end, "Format buffer")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count =  1 }) end, "Next diagnostic")
    map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
    map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics list")

    if client.server_capabilities.documentHighlightProvider then
        local grp = vim.api.nvim_create_augroup("LspDocumentHighlight" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr, group = grp,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr, group = grp,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

-- Diagnostic UI: signs in the gutter only, no inline virtual text. Cycling
-- with [d/]d (or [g/]g via legacy_overrides) auto-opens the float thanks to
-- jump.float = true.
vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
        },
    },
    float = { border = "rounded", source = "if_many" },
    -- nvim 0.12: jump.float is deprecated; use on_jump directly. Also set
    -- wrap so [g/]g cycle past EOF/BOF (overriding the implicit wrap=false
    -- you'd otherwise get from replacing the jump table).
    jump = {
        wrap = true,
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float({
                bufnr = bufnr,
                scope = "cursor",
                focus = false,
                border = "rounded",
                source = "if_many",
            })
        end,
    },
    severity_sort = true,
    update_in_insert = false,
})

-- Define each server config + enable. Modern nvim 0.11 API.
local servers = {
    pyrefly       = {},   -- replaces pyright; user prefers pyrefly
    ts_ls         = {},
    rust_analyzer = {
        settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
    },
    gopls         = {},
    clangd        = {},
    bashls        = {},
    html          = {},
    cssls         = {},
    jsonls        = {},
    yamlls        = {
        -- yaml-language-server defaults to fetching JSON schemas from
        -- schemastore.org synchronously on first request. Behind Tesla's
        -- proxy that hangs and surfaces as "LSP timeout on yaml files".
        -- Disable the schema store + don't auto-attach any schemas. If you
        -- want a specific schema for a project, add it under
        -- settings.yaml.schemas = { ["url"] = "glob/pattern" }.
        settings = {
            yaml = {
                schemaStore     = { enable = false, url = "" },
                schemas         = vim.empty_dict(),
                schemaDownload  = { enable = false },
                validate        = true,
                hover           = true,
                completion      = true,
            },
        },
    },
    taplo         = {},
    sqlls         = {},
    texlab        = {},
    lua_ls        = {
        settings = { Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        } },
    },
    marksman      = {},
}

for name, cfg in pairs(servers) do
    cfg.capabilities = vim.tbl_deep_extend("force", capabilities, cfg.capabilities or {})
    cfg.on_attach = on_attach
    vim.lsp.config(name, cfg)
end

-- Resolve which server launchers are present. Shared by the mason bootstrap
-- (what to install) and the enable pass (what's safe to start now — enabling
-- a server whose binary is missing throws "<server> --stdio failed" popups).
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
-- Known launcher binary for servers whose lspconfig cmd is a function
-- (function-cmds resolve lazily, so we can't peek inside them at config
-- time). Names match those used by mason / the upstream packages.
local known_binary = {
    yamlls         = "yaml-language-server",
    ts_ls          = "typescript-language-server",
    html           = "vscode-html-language-server",
    cssls          = "vscode-css-language-server",
    jsonls         = "vscode-json-language-server",
    bashls         = "bash-language-server",
    marksman       = "marksman",
    taplo          = "taplo",
    sqlls          = "sql-language-server",
    texlab         = "texlab",
    lua_ls         = "lua-language-server",
}

local function find_binary(bin)
    if type(bin) ~= "string" then return false end
    if bin:find("/") then return vim.fn.executable(bin) == 1 end
    if vim.fn.executable(bin) == 1 then return true end
    if vim.fn.executable(mason_bin .. "/" .. bin) == 1 then return true end
    return false
end

local function binary_exists(server_name)
    -- Check a known launcher name first — this catches function-style cmds
    -- (yamlls, ts_ls, html, cssls, jsonls, ...).
    local known = known_binary[server_name]
    if known then return find_binary(known) end

    -- Fall back to the cfg cmd we registered.
    local cfg = vim.lsp.config[server_name]
    if not cfg or not cfg.cmd then return false end
    if type(cfg.cmd) == "function" then return false end  -- can't introspect
    return find_binary(cfg.cmd[1])
end

-- Mason bootstrap policy. stdpath("data") lives on ephemeral /scratch (see
-- init.lua), so a wiped host boots with an empty mason and NO language servers
-- — which silently breaks gd/hover/references. So by default we bootstrap
-- every configured server that isn't already resolvable, and let them reappear
-- on a fresh host. Override with vim.g.nvim_fast2_install_servers:
--     nil / not set → install every server in `servers` not already on PATH.
--     false         → install nothing automatically.
--     true          → install every server in `servers`.
--     a list        → install ONLY those (e.g. {"clangd","lua_ls"}).
-- `:MasonInstall <name>` always works on demand. rust_analyzer ships via
-- rustup on PATH, so the default "not already present" filter skips it (mason
-- would otherwise install a redundant second copy). pyrefly IS a mason package
-- (python), so it bootstraps like the rest.
local install_setting = vim.g.nvim_fast2_install_servers
local ensure_installed
if install_setting == false then
    ensure_installed = {}
elseif install_setting == true then
    ensure_installed = vim.tbl_keys(servers)
elseif type(install_setting) == "table" then
    ensure_installed = install_setting
else
    ensure_installed = {}
    for name in pairs(servers) do
        if not binary_exists(name) then
            table.insert(ensure_installed, name)
        end
    end
end
-- automatic_enable (mason-lspconfig v2) calls vim.lsp.enable() for each server
-- as it finishes installing, reusing the vim.lsp.config() registered above
-- (on_attach + capabilities) — so a freshly bootstrapped server attaches
-- without a restart.
require("mason-lspconfig").setup({
    ensure_installed = ensure_installed,
    automatic_enable = true,
})

-- Enable servers whose launcher is present right now (steady state). Skipping
-- missing ones avoids the "<server> --stdio failed" popups; anything mason is
-- still bootstrapping gets enabled by automatic_enable when it completes.
local enable_list = {}
local skipped = {}
for name in pairs(servers) do
    if binary_exists(name) then
        table.insert(enable_list, name)
    else
        table.insert(skipped, name)
    end
end
vim.lsp.enable(enable_list)
-- Stash the skip list so the user can inspect it via `:lua =vim.g.nvim_fast2_skipped_lsps`
vim.g.nvim_fast2_skipped_lsps = skipped
