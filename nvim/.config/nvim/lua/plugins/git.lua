-- Git plugins
return {
  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -- Neogit (inline Magit-style git UI)
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    opts = {},
  },


  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "╏" },
          topdelete = { text = "╏" },
          changedelete = { text = "┃" },
        },
        signcolumn = true,
        numhl = false,
        linehl = true,
        watch_gitdir = {
          enable = true,
          interval = 1000,
          follow_files = true,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          -- Floating indicator helper
          local function show_indicator(idx, total, label)
            local text = string.format(" %d/%d %s ", idx, total, label)
            local width = #text
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
            local win = vim.api.nvim_open_win(buf, false, {
              relative = "editor",
              row = vim.o.lines - 4,
              col = math.floor((vim.o.columns - width) / 2),
              width = width,
              height = 1,
              style = "minimal",
              border = "rounded",
              focusable = false,
            })
            vim.api.nvim_set_hl(0, "GitIndicator", { bg = "#1d2021", fg = "#ebdbb2", bold = true })
            vim.api.nvim_win_set_option(win, "winhl", "Normal:GitIndicator,FloatBorder:GitIndicator")
            vim.defer_fn(function()
              if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
              if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
            end, 1500)
          end

          -- Hunk navigation with indicator (gj/gk = vertical within file)
          local function goto_hunk(direction)
            local hunks = gs.get_hunks()
            if not hunks or #hunks == 0 then return end
            if direction == "next" then
              gs.next_hunk({ navigation_message = false })
            else
              gs.prev_hunk({ navigation_message = false })
            end
            vim.schedule(function()
              local cursor = vim.api.nvim_win_get_cursor(0)[1]
              local new_hunks = gs.get_hunks() or {}
              for i, hunk in ipairs(new_hunks) do
                if cursor >= hunk.added.start and cursor <= hunk.added.start + math.max(hunk.added.count - 1, 0) then
                  show_indicator(i, #new_hunks, "hunks")
                  return
                end
              end
            end)
          end

          map("n", "gj", function() goto_hunk("next") end, "Next hunk")
          map("n", "gk", function() goto_hunk("prev") end, "Previous hunk")

          -- Jump to next/prev modified file
          local function goto_modified_file(direction)
            -- Don't run from nvim-tree or special buffers
            if vim.bo.filetype == "NvimTree" or vim.bo.buftype ~= "" then
              return
            end

            -- Get top-level git root (parent repo if in submodule)
            local file_dir = vim.fn.expand("%:p:h")
            if file_dir == "" then return end

            -- Check if we're in a submodule first
            local superproject = vim.fn.systemlist("git -C " .. vim.fn.shellescape(file_dir) .. " rev-parse --show-superproject-working-tree 2>/dev/null")[1]
            local git_root
            if superproject and superproject ~= "" then
              git_root = superproject
            else
              git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(file_dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
            end
            if not git_root or git_root == "" then return end

            local files = {}

            -- Get modified files from main repo
            local raw_files = vim.fn.systemlist("git -C " .. vim.fn.shellescape(git_root) .. " diff --name-only 2>/dev/null")
            for _, f in ipairs(raw_files) do
              local full_path = git_root .. "/" .. f
              if vim.fn.filereadable(full_path) == 1 then
                table.insert(files, full_path)
              elseif vim.fn.isdirectory(full_path) == 1 then
                -- This is a submodule - get its modified files too
                local sub_files = vim.fn.systemlist("git -C " .. vim.fn.shellescape(full_path) .. " diff --name-only 2>/dev/null")
                for _, sf in ipairs(sub_files) do
                  local sub_full_path = full_path .. "/" .. sf
                  if vim.fn.filereadable(sub_full_path) == 1 then
                    table.insert(files, sub_full_path)
                  end
                end
              end
            end
            if #files == 0 then return end

            -- Find current file in the list (files already contains absolute paths)
            local current_path = vim.fn.expand("%:p")
            local current_idx = 1
            for i, f in ipairs(files) do
              if f == current_path then
                current_idx = i
                break
              end
            end

            local new_idx
            if direction == "next" then
              new_idx = (current_idx % #files) + 1
            else
              new_idx = ((current_idx - 2) % #files) + 1
            end

            local target = files[new_idx]
            -- Skip if target is same as current (only 1 file)
            if target == current_path then return end

            vim.cmd("edit " .. vim.fn.fnameescape(target))
            show_indicator(new_idx, #files, "files")
          end

          -- File navigation (gl/gh = horizontal between files)
          map("n", "gl", function() goto_modified_file("next") end, "Next modified file")
          map("n", "gh", function() goto_modified_file("prev") end, "Previous modified file")

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
          map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
          map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
          map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
          map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
          map("n", "<leader>hd", gs.diffthis, "Diff this")
          -- Undo hunk (gu = git undo)
          map("n", "gu", gs.reset_hunk, "Undo hunk")
          map("v", "gu", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Undo hunk")
        end,
      })
    end,
  },

  -- Fugitive
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" },
  },

  -- Unified inline diffs (shows diffs directly in buffer)
  {
    "axkirillov/unified.nvim",
    lazy = false,
    keys = {
      { "<leader>dv", "<cmd>Unified<cr>", desc = "Toggle unified diff view" },
      { "<leader>du", "<cmd>Unified<cr>", desc = "Toggle unified diff view" },
    },
    config = function()
      require("unified").setup({
        -- Display settings
        default_keymaps = true,

        -- Sign configuration
        signs = {
          add = "▎",
          change = "▎",
          delete = "▎",
        },

        -- Highlight configuration
        highlights = {
          add = "UnifiedAdded",
          change = "UnifiedChanged",
          delete = "UnifiedDeleted",
        },
      })

      -- Hunk navigation (uses same keys as gitsigns for consistency)
      local nav = require("unified.navigation")
      vim.keymap.set("n", "gj", nav.next_hunk, { desc = "Next hunk" })
      vim.keymap.set("n", "gk", nav.previous_hunk, { desc = "Previous hunk" })

      -- Setup highlighting for added/deleted lines
      local set_hl = vim.api.nvim_set_hl
      set_hl(0, "UnifiedAdded", { bg = "#1a3a1a", fg = "#90ee90" })
      set_hl(0, "UnifiedDeleted", { bg = "#3a1a1a", fg = "#ff6b6b" })
      set_hl(0, "UnifiedChanged", { bg = "#2a2a1a", fg = "#ffeb3b" })
    end,
  },

  -- Inline deleted lines (shows deleted git lines as virtual text)
  {
    -- dir = "~/Desktop/code/inline-deleted.nvim",
    "mb6611/inline-deleted.nvim",
    dependencies = { "lewis6991/gitsigns.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "<leader>gi", function() require("inline-deleted").toggle() end, desc = "Toggle inline deleted" },
      { "<leader>ge", function() require("inline-deleted").expand() end, desc = "Expand deleted hunk" },
    },
  },
}
