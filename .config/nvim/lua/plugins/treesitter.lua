-- Treesitter
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- Treesitter should NOT be lazy-loaded on events
    -- so it's loaded immediately at startup for correct highlighting.
    lazy = false,

    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },

    opts = {
      -- Parsers to install
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "markdown",
        "markdown_inline",
        "bash",
        "latex",
        -- "dockerfile",  -- Disabled due to tarball download issues
        "prisma",
        "yaml",
      },

      sync_install = false,

      -- Auto-install missing parsers (safe without tree-sitter CLI)
      auto_install = true,

      -- Advanced: ignore certain parsers
      ignore_install = { "dockerfile" },  -- Prevent auto-reinstall due to corrupted tarball

      highlight = {
        enable = true,

        -- Disable highlight for helm (use vim-helm instead) and large files
        disable = function(lang, buf)
          -- Use vim-helm syntax instead of Treesitter for helm files
          if lang == "helm" or vim.bo[buf].filetype == "helm" then
            return true
          end
          local max_filesize = 150 * 1024 -- 150 KB (safer default)
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },
    },

    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },

  -- JSX/TSX commenting support
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = { enable_autocmd = false },
  },
}
