-- =============================================================================
--                                  MU-VIM
--                       A Beginner-Friendly Neovim Setup
-- =============================================================================
-- This is the main entry point for your Neovim configuration.
-- It coordinates setting options, loading plugins, and defining keymaps.
--
-- For details and documentation, visit:
-- https://github.com/mu-vim/mu-vim
-- =============================================================================

-- Set the leader key to Space.
-- This MUST be defined before loading plugins and keymaps so they register
-- correct keybindings using '<leader>'.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core editor options (line numbers, spacing, search behaviors, etc.)
require("core.options")

-- Bootstrap and load the plugin manager (lazy.nvim)
require("core.lazy")

-- Load keymaps and shortcuts (toggles, movement helpers, etc.)
require("core.keymaps")

-- Load automatic behaviors (highlight on copy, auto-resize, etc.)
require("core.autocmds")
