-- =============================================================================
--                             LAZY.NVIM BOOTSTRAPPER
-- =============================================================================
-- This file installs and initializes lazy.nvim, the Neovim plugin manager.
-- It will automatically clone the manager if it is not found on startup.
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim and load plugins from lua/plugins/
require("lazy").setup({
  spec = {
    -- Automatically import all plugin specifications from lua/plugins/
    { import = "plugins" },
  },
  defaults = {
    -- By default, plugins are not lazy-loaded to keep things simple for beginners
    lazy = false,
  },
  -- Configure lazy-lock.json path to match user configuration directory
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  install = { colorscheme = { "catppuccin-mocha" } },
  checker = { enabled = false }, -- Disable automatic update checks to prevent startup noise
  change_detection = { notify = false }, -- Do not notify on config changes to keep it clean
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
