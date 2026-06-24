-- =============================================================================
--                               NEO-TREE FILE EXPLORER
-- =============================================================================
-- Neo-tree displays the workspace folder directory structure as a sidebar,
-- making it comfortable for users transitioning from typical graphical IDEs.
-- =============================================================================

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- status/file type icons
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true, -- Close Neo-tree if it is the only window left open
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          filtered_items = {
            visible = false, -- show hidden files by toggling
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true, -- highlight the active open file in the directory tree
          },
          use_libuv_file_watcher = true, -- Automatically refresh tree on outside changes
        },
        window = {
          width = 30,
          mappings = {
            ["o"] = "open",
            ["v"] = "open_vsplit",
            ["h"] = "open_split",
          },
        },
      })

      -- --- Keymaps (All with `desc` for Which-Key visualization) ---
      local keymap = vim.keymap.set
      keymap("n", "<leader>e", "<cmd>Neotree toggle left<CR>", { desc = "Toggle file explorer sidebar" })
      keymap("n", "<C-n>", "<cmd>Neotree toggle left<CR>", { desc = "Toggle file explorer sidebar (IDE-style)" })
    end,
  },
}
