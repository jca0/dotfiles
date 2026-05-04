return {
  -- dir = "~/Desktop/code/claude-multi.nvim",
  "mb6611/claude-multi.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  opts = {
    keymaps = {
      prev_session = "<M-h>",
      next_session = "<M-l>",
    },
  },
}
