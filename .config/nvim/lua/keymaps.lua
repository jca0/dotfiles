-- Keymaps (converted from keymaps.vim)

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Disable ex mode
map("n", "q:", "<Nop>", opts)

-- Delete to black hole register (non-buffer overwrite)
map({ "n", "v" }, "<leader>d", '"_d', opts)
map({ "n", "v" }, "<leader>D", '"_D', opts)
map({ "n", "v" }, "<leader>c", '"_c', opts)
map({ "n", "v" }, "<leader>C", '"_C', opts)
map({ "n", "v" }, "<leader>x", '"_x', opts)
map({ "n", "v" }, "<leader>X", '"_X', opts)

-- Insert mode escape alternatives
map("i", "jc", "<Esc>", opts)
map("i", "jf", "<Esc>:w<CR>", opts)
map("i", "jj", "<Esc>:w<CR>", opts)
map("i", "kk", "<Esc>:w<CR>", opts)
map("i", "jk", "<Esc>:w<CR>", opts)
map("i", "<C-c>", "<Esc>:w<CR>", opts)

-- Switch to alternate buffer
map("n", "<C-e>", "<C-^>", opts)

-- Visual line
map("n", "<leader>v", "V", opts)

-- Folding
map("n", "<leader>f", "za", opts)
map("v", "<leader>z", "zf", opts)

-- Insert newline without entering insert mode
map("n", "<leader>o", "o<Esc>k", opts)
map("n", "<leader>O", "O<Esc>j", opts)

-- Bracket jumping
map({ "n", "v" }, "<leader>w", "%", opts)

-- Fast vertical movement (Shift-j/k)
map({ "n", "v" }, "J", "10j", opts)
map({ "n", "v" }, "K", "10k", opts)

-- Line moving (Alt+j/k)
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Line moving (Meta+j/k alternative)
map("n", "<M-j>", ":m .+1<CR>==", opts)
map("n", "<M-k>", ":m .-2<CR>==", opts)
map("i", "<M-j>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<M-k>", "<Esc>:m .-2<CR>==gi", opts)
map("v", "<M-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<M-k>", ":m '<-2<CR>gv=gv", opts)

-- Clipboard (macOS)
map({ "n", "x" }, "<leader>y", ":w !pbcopy<CR><CR>", opts)
map("n", "<leader>yy", ":%w !pbcopy<CR><CR>", opts)

-- Telescope mappings defined in lua/plugins/telescope.lua

-- LaTeX shortcuts
map("n", "<leader>bb", ":w<cr>:!pdflatex %:r.tex && bibtex %:r.aux && pdflatex %:r.tex && pdflatex %:r.tex && rm %:r.aux %:r.log %:r.blg %:r.bbl<cr>", opts)
map("n", "<leader>bv", ":!zathura %:r.pdf > /dev/null 2>&1 &<cr><cr>", opts)

-- Twilight toggle
map("n", "<leader>z", "<cmd>Twilight<CR>", opts)

-- Commands
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("PWF", function() print(vim.fn.expand("%")) end, {})
vim.api.nvim_create_user_command("S", "source ~/.config/nvim/init.lua", {})

-- DiffWithSaved command
vim.api.nvim_create_user_command("DiffSaved", function()
  local filetype = vim.bo.filetype
  vim.cmd("diffthis")
  vim.cmd("vnew | r # | normal! 1Gdd")
  vim.cmd("diffthis")
  vim.cmd("setlocal bt=nofile bh=wipe nobl noswf ro ft=" .. filetype)
end, {})

-- Note mode command
vim.api.nvim_create_user_command("Note", function()
  vim.opt_local.spell = true
  vim.opt_local.syntax = "markdown"
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
end, {})

-- Terminal commands
-- Open horizontal terminal split
vim.keymap.set("n", "<leader>ts", function()
  vim.cmd("split | terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal (horizontal split)" })

-- Open vertical terminal split
vim.keymap.set("n", "<leader>ti", function()
  vim.cmd("vsplit | terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal (vertical split)" })

-- Exit terminal mode
-- terminal escape
vim.keymap.set("t", "xx", [[<C-\><C-n>]], { noremap = true })


-- Diagnostic popup on demand
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, {
    focus = false,
    border = "rounded",
    source = "always",
  })
end, { desc = "Show diagnostic popup" })

-- Global diagnostic keymaps
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]G", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })

vim.keymap.set("n", "[G", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev error" })
