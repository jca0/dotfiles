-- Markdown and LaTeX
return {
  -- In-buffer markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = {
        enabled = true,
        sign = false,
        icons = {},
        backgrounds = {},
      },
      code = {
        enabled = true,
        sign = false,
        style = "normal",
        border = "thin",
      },
      bullet = {
        enabled = true,
        icons = { "•", "◦", "▸", "▹" },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "☐ " },
        checked = { icon = "☑ " },
      },
      quote = { enabled = true },
      pipe_table = { enabled = true, style = "full" },
      win_options = {
        conceallevel = { rendered = 2 },
      },
    },
  },

  -- Markdown preview (browser)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    init = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
    end,
  },

  -- VimTeX
  {
    "lervag/vimtex",
    ft = { "tex", "latex" },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_general_viewer = "okular"
      vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_quickfix_disable_warning_message = 1
      vim.g.vimtex_syntax_conceal_disable = 1
    end,
  },

  -- TeX conceal
  {
    "KeitaNakamura/tex-conceal.vim",
    ft = { "tex", "latex" },
  },
}