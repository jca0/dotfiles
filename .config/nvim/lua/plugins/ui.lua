-- UI plugins

-- Clean UI inside terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    local buf = args.buf
    -- Only modify *real terminal* buffers
    if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then

      -- Disable indent-blankline *locally*
      vim.b[buf].ibl_disabled = true

      -- Disable mini.indentscope *locally*
      vim.b[buf].miniindentscope_disable = true

    end
  end,
})


return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Indent guides (static lines - dim)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "▏", highlight = "IblIndent" },
      scope = { enabled = false },
    },
    config = function(_, opts)
      -- Link to Comment for dim appearance (adapts to colorscheme)
      vim.api.nvim_set_hl(0, "IblIndent", { link = "Comment" })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function() vim.api.nvim_set_hl(0, "IblIndent", { link = "Comment" }) end,
      })
      require("ibl").setup(opts)
    end,
  },

  -- Current scope highlight (more reliable than ibl scope)
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      return {
        symbol = "▏",
        options = { try_as_border = true },
        draw = { delay = 0, animation = require("mini.indentscope").gen_animation.none() },
      }
    end,
    config = function(_, opts)
      -- Link to Function for visible scope (adapts to colorscheme)
      local function set_hl()
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "Function" })
      end
      set_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "lazy", "mason", "neo-tree", "Trouble", "dashboard" },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
      require("mini.indentscope").setup(opts)
    end,
  },

  -- Rainbow delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = { [""] = rainbow_delimiters.strategy["global"] },
        query = { [""] = "rainbow-delimiters" },
        highlight = {
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
          "RainbowDelimiterYellow",
          "RainbowDelimiterGreen",
          "RainbowDelimiterOrange",
        },
      }
    end,
  },

  -- Color highlighter
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      user_default_options = {
        css = true,
        tailwind = true,
      },
    },
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },

  -- Better UI components
  { "stevearc/dressing.nvim", event = "VeryLazy" },

  -- Web devicons
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
