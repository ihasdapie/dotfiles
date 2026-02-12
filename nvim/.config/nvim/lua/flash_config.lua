require("flash").setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    multi_window = true,
    forward = true,
    wrap = true,
    mode = "exact",
    incremental = false,
    exclude = {
      "notify",
      "cmp_menu",
      "noice",
      "flash_prompt",
      function(win)
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
  },
  jump = {
    jumplist = true,
    pos = "start",
    nohlsearch = true,
    autojump = true,
  },
  label = {
    uppercase = false,
    after = false,
    before = { 0, 0 },
    style = "overlay",
    reuse = "all",
    distance = true,
    min_pattern_length = 2,
  },
  highlight = {
    backdrop = true,
    matches = true,
    priority = 5000,
    groups = {
      match = "FlashMatch",
      current = "FlashCurrent",
      backdrop = "FlashBackdrop",
      label = "FlashLabel",
    },
  },
  modes = {
    search = {
      enabled = false,
    },
    char = {
      enabled = true,
      autohide = false,
      jump_labels = false,
      multi_line = true,
      label = { exclude = "hjkliardc" },
      keys = { "f", "F", "t", "T", ";", "," },
      highlight = { backdrop = true },
      jump = { register = false, autojump = false },
    },
    treesitter = {
      labels = "abcdefghijklmnopqrstuvwxyz",
      jump = { pos = "range", autojump = true },
      search = { incremental = false },
      label = { before = true, after = true, style = "inline" },
      highlight = { backdrop = false, matches = false },
    },
  },
  prompt = {
    enabled = true,
    prefix = { { "⚡", "FlashPromptIcon" } },
  },
})

vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

vim.keymap.set("n", "S", function()
  require("flash").jump({ search = { multi_window = true } })
end, { desc = "Flash (multi-window)" })

vim.keymap.set({ "n", "x", "o" }, "r", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

--[[ vim.keymap.set("o", "R", function()
  require("flash").remote()
end, { desc = "Remote Flash" }) ]]
