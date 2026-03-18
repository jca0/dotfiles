-- Iron.nvim (REPL)
return {
  {
    "hkupty/iron.nvim",
    keys = {
      { "<space>sc", desc = "Send motion to REPL" },
      { "<space>sf", desc = "Send file to REPL" },
      { "<space>sl", desc = "Send line to REPL" },
    },
    config = function()
      local iron = require("iron.core")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = { command = { "bash" } },
            python = {
              command = { "python3" },
              format = require("iron.fts.common").bracketed_paste,
            },
          },
          repl_open_cmd = require("iron.view").split.vertical.botright(60),
        },
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })

      -- Terminal mode mapping
      vim.keymap.set("t", "jf", function()
        vim.cmd("stopinsert")
        local repl = iron.get_current_repl()
        if repl then
          iron.focus_on(repl)
        end
      end, { desc = "Exit terminal mode" })
    end,
  },
}