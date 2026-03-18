-- Telescope

-- Get the project root based on current buffer's file location
local function get_project_root()
  -- Get directory of current buffer, or cwd if no file
  local buf_dir = vim.fn.expand("%:p:h")
  if buf_dir == "" or buf_dir == "." then
    buf_dir = vim.fn.getcwd()
  end

  -- Find git root from buffer's directory
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(buf_dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
  if vim.v.shell_error == 0 and git_root and git_root ~= "" then
    return git_root
  end

  return buf_dir
end

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "jvgrootveld/telescope-zoxide",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files({ cwd = get_project_root() }) end, desc = "Find files" },
      { "<C-n>", function() require("telescope.builtin").find_files({ cwd = get_project_root() }) end, desc = "Find files" },
      { "<leader>fj", "<cmd>Telescope git_files<cr>", desc = "Git files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep({ cwd = get_project_root() }) end, desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fz", "<cmd>Telescope zoxide list<cr>", desc = "Zoxide" },
    },
    opts = {
      defaults = {
        layout_strategy = "flex",
        layout_config = {
          flex = {
            flip_columns = 120, -- switch to vertical when width < 120
          },
          horizontal = {
            preview_width = 0.5,
          },
          vertical = {
            preview_height = 0.4,
          },
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
          n = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        find_files = { theme = "dropdown" },
        live_grep = {
          additional_args = function() return { "--sort=path" } end,
        },
      },
      extensions = {
        zoxide = {
          prompt_title = "[ Zoxide directories ]",
          mappings = {
            default = {
              action = function(selection)
                vim.cmd.lcd(selection.path)
              end,
              after_action = function(selection)
                print("Directory changed to " .. selection.path)
              end,
            },
          },
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("zoxide")
      pcall(telescope.load_extension, "fzf")
    end,
  },
}