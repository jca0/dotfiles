-- Autocommands (converted from autocmds.vim)

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Jump to previous position when opening a file
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})


-- Auto-reload file when it changes externally
augroup("AutoReload", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = "AutoReload",
  command = "checktime",
})

-- Toggle relative line numbers based on focus/mode
augroup("NumberToggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = "NumberToggle",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = "NumberToggle",
  callback = function()
    vim.wo.relativenumber = false
  end,
})

-- Persistent folds
augroup("AutoSaveFolds", { clear = true })
autocmd("BufWinLeave", {
  group = "AutoSaveFolds",
  pattern = "*",
  command = "silent! mkview",
})
autocmd("BufWinEnter", {
  group = "AutoSaveFolds",
  pattern = "*",
  command = "silent! loadview",
})


-- Format Prisma files on save
augroup("PrismaFormat", { clear = true })
autocmd("BufWritePre", {
  group = "PrismaFormat",
  pattern = "*.prisma",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Restore cursor on VimLeave
autocmd("VimLeave", {
  callback = function()
    vim.opt.guicursor = "a:ver25-blinkwait700-blinkon400-blinkoff250-Cursor/lCursor"
  end,
})

-- Clear search highlights on startup
vim.cmd("nohlsearch")

-- Detect Helm templates (YAML files with Go template syntax)
vim.filetype.add({
  pattern = {
    [".*/templates/.*%.yaml"] = "helm",
    [".*/templates/.*%.tpl"] = "helm",
    ["helmfile.*%.yaml"] = "helm",
  },
})

-- Highlight on yank
augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = "HighlightYank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})
