-- Colorschemes
-- Using terminal colors from iTerm2
return {
  {
    "shapeoflambda/dark-purple.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("default")
      -- Transparency - let iTerm2 background show through
      vim.cmd("hi! Normal ctermbg=NONE guibg=NONE")
      vim.cmd("hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE")
      vim.cmd("hi Comment gui=NONE")
    end,
  },
}
