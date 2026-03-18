-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
  spec = {
    -- { import = "plugins.claude" },
    -- { import = "plugins.claudecode" },  -- Disabled: Use plugins.claude-multi instead for multi-session support
    { import = "plugins.claude-multi" },   -- Multi-session Claude Code manager
    { import = "plugins.colorscheme" },
    { import = "plugins.editor" },
    { import = "plugins.ui" },
    { import = "plugins.git" },
    { import = "plugins.lsp" },
    { import = "plugins.completion" },
    { import = "plugins.telescope" },
    { import = "plugins.treesitter" },
    { import = "plugins.comment" },
    { import = "plugins.iron" },
    -- { import = "plugins.avante" },
    { import = "plugins.markdown" },
    { import = "plugins.neoscroll" },
    -- { import = "plugins.obsidian" },
  },
  defaults = { lazy = false },
  install = { colorscheme = { "dark_purple", "habamax" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
