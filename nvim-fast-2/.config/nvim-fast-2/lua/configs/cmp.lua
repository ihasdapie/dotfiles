-- nvim-cmp — completion engine. Replaces coc#pum* popup completion.

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping(function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before = vim.api.nvim_get_current_line():sub(1, col)
            local word = before:match("(%S+)$") or ""
            if #word > 0 and word:find("[/~]") then
                cmp.complete()
            else
                if cmp.visible() then cmp.close() end
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<C-x><C-f>", true, false, true),
                    "n", false
                )
            end
        end),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-CR>"] = cmp.mapping.confirm({ select = true }),
        -- <Tab>: confirm first/selected item / expand snippet / trigger completion.
        -- Single Tab accepts the top suggestion; use <C-n>/<C-p> to browse.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp",         priority = 1000 },
        { name = "path",             priority = 900,
          option = {
              trailing_slash = true,
              label_trailing_slash = true,
              get_cwd = function() return vim.fn.getcwd() end,
          },
        },
        { name = "luasnip",          priority = 750 },
        -- ultisnips removed: its cmp source crashes with `pairs(nil)` because
        -- the Python UltiSnips backend returns nil from load_snippets. LuaSnip
        -- already loads the same vim-snippets via snipmate loader (configs/luasnip.lua).
        { name = "buffer",           priority = 500 },
        { name = "emoji",            priority = 100 },
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = function()
                return math.floor(vim.o.columns * 0.45)
            end,
            ellipsis_char = "...",
            menu = {
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
                emoji = "[Emoji]",
            },
        }),
    },
    experimental = { ghost_text = true },
})

-- Cmdline completion
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
})
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    matching = { disallow_symbol_nonprefix_matching = false },
})
