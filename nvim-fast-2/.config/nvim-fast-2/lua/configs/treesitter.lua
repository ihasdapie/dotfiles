-- nvim-treesitter v0.10.0 (configs API).
-- We use the stable v0.9-style module system. v1 (main branch) is still alpha.
--
-- NOTE: this file ALSO patches nvim-treesitter's query predicates/directives
-- after setup (see "Predicate compat shim" at the bottom). nvim 0.12 changed
-- query handlers to always receive `match[capture_id]` as a TSNode[] list,
-- and stopped honoring the `{ all = false }` opt-out that v0.10.0 relies on.
-- Without the shim, every markdown-injection parse crashes with
-- `attempt to call method 'range' (a nil value)`, which then takes down
-- snacks.indent/scope/image (everything that parses via treesitter).

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua", "vim", "vimdoc", "query", "regex", "comment",
        "bash", "fish", "make",
        "html", "css", "scss", "javascript", "typescript", "tsx",
        "json", "jsonc", "yaml", "toml", "vue",
        "c", "cpp", "rust", "go", "gomod", "gosum", "java",
        "python", "ruby", "perl",
        "markdown", "markdown_inline",  -- latex removed (parser CLI errors)
        "diff", "git_config", "git_rebase", "gitcommit", "gitignore", "gitattributes",
        "dockerfile", "sql", "graphql", "asm",
    },
    sync_install = false,
    auto_install = false,           -- old tree-sitter CLI here can't grok --no-bindings
    ignore_install = {},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection    = "gnn",
            node_incremental  = "grn",
            scope_incremental = "grc",
            node_decremental  = "grm",
        },
    },
})

----------------------------------------------------------------------------
-- Predicate compat shim — see header note. Re-registers nvim-treesitter's
-- buggy directives/predicates with `force = true` and a wrapper that
-- normalizes `match[capture_id]` to a single TSNode regardless of whether
-- nvim hands us the legacy single value or the new TSNode[] list.
----------------------------------------------------------------------------
do
    local query = vim.treesitter.query
    local opts  = { force = true, all = false }

    -- Pull a single TSNode out of `match[capture_id]`. Tolerates:
    --   - new nvim 0.10/0.11/0.12 form: TSNode[] (returns [1])
    --   - old form: TSNode  (returns as-is)
    --   - missing capture: nil
    local function first_node(match, capture_id)
        local v = match[capture_id]
        if v == nil then return nil end
        if type(v) == "userdata" then return v end          -- legacy single TSNode
        if type(v) == "table"    then return v[1] end       -- new TSNode[]
        return nil
    end

    -- nth?  → match if node is the nth child of its parent
    query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
        local node = first_node(match, pred[2])
        if not node or not node:parent() then return false end
        local n = tonumber(pred[3])
        local parent = node:parent()
        for i = 0, parent:named_child_count() - 1 do
            if parent:named_child(i) == node then return i == n end
        end
        return false
    end, opts)

    -- has-ancestor? / has-parent? → match if any ancestor (or parent for
    -- has-parent?) has one of the listed types.
    local function has_ancestor(match, _pattern, _bufnr, pred, only_parent)
        local node = first_node(match, pred[2])
        if not node then return false end
        local types = {}
        for i = 3, #pred do types[pred[i]] = true end
        local cur = node:parent()
        while cur do
            if types[cur:type()] then return true end
            if only_parent then return false end
            cur = cur:parent()
        end
        return false
    end
    query.add_predicate("has-ancestor?", function(m, p, b, pr) return has_ancestor(m, p, b, pr, false) end, opts)
    query.add_predicate("has-parent?",   function(m, p, b, pr) return has_ancestor(m, p, b, pr, true)  end, opts)

    -- is? → match if locals.find_definition kind matches one of the listed
    -- types. Only meaningful when nvim-treesitter's locals module is loaded.
    local locals_ok, locals = pcall(require, "nvim-treesitter.locals")
    query.add_predicate("is?", function(match, _pattern, bufnr, pred)
        if not locals_ok then return false end
        local node = first_node(match, pred[2])
        if not node then return false end
        local types = {}
        for i = 3, #pred do types[pred[i]] = true end
        local _, _, kind = locals.find_definition(node, bufnr)
        return types[kind] == true
    end, opts)

    -- kind-eq? → node:type() ∈ pred[3..]
    query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
        local node = first_node(match, pred[2])
        if not node then return false end
        for i = 3, #pred do
            if node:type() == pred[i] then return true end
        end
        return false
    end, opts)

    -- set-lang-from-mimetype! → use HTML <script type="…/lang"> as the
    -- injection language. Only matters for HTML; harmless to register.
    query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
        local node = first_node(match, pred[2])
        if not node then return end
        local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
        if type_attr_value:find("/", 1, true) then
            local parts = vim.split(type_attr_value, "/", { plain = true })
            metadata["injection.language"] = parts[#parts]
        end
    end, opts)

    -- set-lang-from-info-string! → markdown ```lang code blocks. The one
    -- that was actually crashing in your trace.
    local non_filetype_match_injection_language_aliases = {
        bash = "bash", html = "html", javascript = "javascript",
        json = "json", markdown = "markdown", python = "python",
        rust = "rust", typescript = "typescript", ts = "typescript",
    }
    local function get_parser_from_markdown_info_string(injection_alias)
        local m = vim.filetype.match({ filename = "a." .. injection_alias })
        return m or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
    end
    query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local node = first_node(match, pred[2])
        if not node then return end
        local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
    end, opts)

    -- make-range! → no-op (silences a warning). Same as v0.10.0.
    query.add_directive("make-range!", function() end, opts)

    -- downcase! → lower-case captured node text into metadata.text
    query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
        local node = first_node(match, pred[2])
        if not node then return end
        local text = vim.treesitter.get_node_text(node, bufnr)
        metadata[pred[2]] = metadata[pred[2]] or {}
        metadata[pred[2]].text = text:lower()
    end, opts)
end
