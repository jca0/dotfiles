-- Neovim Configuration Entry Point
-- Using lazy.nvim as plugin manager

-- Set up config path (needed when using -u flag)
local config_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
vim.opt.runtimepath:prepend(config_path)
vim.opt.runtimepath:append(config_path .. "/after")

-- Set leader key before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("options")
require("autocmds")
require("keymaps")
--
-- Bootstrap lazy.nvim and load plugins
require("plugins")
