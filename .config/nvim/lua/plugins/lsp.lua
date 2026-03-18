-- LSP Configuration (using Neovim 0.11+ native API)
return {
  -- Mason (LSP/DAP/Linter installer)
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },

  -- Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "tailwindcss",
        "html",
        "cssls",
        "jsonls",
        "prismals",

      },
      automatic_installation = true,
    },
  },

  -- LSP Config (for server configs, still needed for now)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Get capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Diagnostic keymaps
      vim.keymap.set("n", "gn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set("n", "gN", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "ge", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end)
      vim.keymap.set("n", "gE", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)

      -- LSP attach keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
          end
          map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "Go to definition")
          map("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", "Go to type definition")
          map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", "Go to implementation")
          map("n", "gr", "<cmd>Telescope lsp_references<cr>", "References")
          map("n", "gh", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>rf", vim.lsp.buf.code_action, "Code action")
          map({ "n", "v" }, "<leader>f", vim.lsp.buf.format, "Format")
          map("n", "gf", vim.lsp.buf.code_action, "Quick fix")
        end,
      })

      -- Use new vim.lsp.config API (Neovim 0.11+)
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        pyright = {},
        ts_ls = {},
        tailwindcss = {
          filetypes = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
        },
        html = {},
        cssls = {},
        jsonls = {},
        prismals = {},

        sourcekit = {
          cmd = { "sourcekit-lsp" },
          filetypes = { "swift", "objc", "objcpp" },
        },
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
      end

      -- Enable all configured servers
      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
