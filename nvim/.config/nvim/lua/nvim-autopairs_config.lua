local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({
    enable_check_bracket_line = false,
    ignored_next_char = "[%(%w%.%'%\"%$]", -- will ignore alphanumeric, ., ', $, and " symbols
    check_ts = true,
    enable_afterqot = true,
})


-- `tex` math
npairs.add_rule(Rule("$$", "$$", "md"))
npairs.add_rule(Rule("$$ "," $$","pandoc"))

-- for hugo inline katex
npairs.add_rule(Rule("\\( "," \\\\","pandoc"))  -- no need for closing bracket since the default bracket rule appends that for us


-- spaces in brackets
npairs.add_rules {
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ', ' )')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%)') ~= nil
      end)
      :use_key(')'),
  Rule('{ ', ' }')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%}') ~= nil
      end)
      :use_key('}'),
  Rule('[ ', ' ]')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%]') ~= nil
      end)
      :use_key(']')
}



npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))


