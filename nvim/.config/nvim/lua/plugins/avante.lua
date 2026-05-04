-- Avante (AI assistant)
return {
  -- Dependencies
  { "stevearc/dressing.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },

  -- Image clip
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      embed_image_as_base64 = false,
      prompt_for_file_name = false,
      drag_and_drop = { insert_mode = true },
      use_absolute_path = true,
    },
  },

  -- Render markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    opts = { file_types = { "markdown", "Avante" } },
  },

  -- Avante
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "HakonHarnes/img-clip.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "folke/snacks.nvim", -- for input provider snacks
      "zbirenbaum/copilot.lua", -- for providers='copilot'
    },
    opts = {
      provider = "openai",
      providers = {
        openai = {
          model = "gpt-4o",
          api_key_name = { "security", "find-generic-password", "-s", "avante.nvim", "-w" },
          max_tokens = 4096,
        },
      },
      auto_suggestions_provider = "copilot",
      rag_service = {
        enabled = false,
        host_mount = os.getenv("HOME"),
        provider = "openai",
        endpoint = "https://api.openai.com/v1",
      },
      behaviour = {
        auto_suggestions = true,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = { next = "]]", prev = "[[" },
        submit = { normal = "<CR>", insert = "<C-s>" },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      hints = { enabled = true },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = { enabled = true, align = "center", rounded = true },
        input = { prefix = "> " },
        edit = { border = "rounded", start_insert = true },
        ask = {
          floating = false,
          start_insert = true,
          border = "rounded",
          focus_on_apply = "ours",
        },
      },
      highlights = {
        diff = { current = "DiffText", incoming = "DiffAdd" },
      },
      diff = {
        autojump = true,
        list_opener = "copen",
        override_timeoutlen = 500,
      },
    },
    config = function(_, opts)
      -- Diff highlights
      vim.cmd([[
        highlight DiffAdd    ctermfg=Green  ctermbg=NONE guifg=#00FF00 guibg=NONE
        highlight DiffChange ctermfg=Yellow ctermbg=NONE guifg=#FFFF00 guibg=NONE
        highlight DiffDelete ctermfg=Red    ctermbg=NONE guifg=#FF0000 guibg=NONE
        highlight DiffText   ctermfg=White  ctermbg=DarkRed guifg=#FFFFFF guibg=#5C0000
      ]])

      require("avante_lib").load()
      require("avante").setup(opts)
    end,
  },
}
