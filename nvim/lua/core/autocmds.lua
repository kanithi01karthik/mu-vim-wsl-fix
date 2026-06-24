-- =============================================================================
--                             AUTOCOMMANDS (AUTOCMDS)
-- =============================================================================
-- Autocommands run actions automatically when specific events occur in Neovim
-- (e.g., opening a file, saving, resizing windows).
-- =============================================================================

-- Define a group for general autocommands so they don't duplicate on reload
local group = vim.api.nvim_create_augroup("MuVimGeneral", { clear = true })

-- --- 1. Highlight on Yank ---
-- Briefly flashes the copied/yanked text. Extremely helpful visual cue!
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 150,
    })
  end,
  desc = "Flash visual selection on copy/yank",
})

-- --- 2. Auto-Resize Window Splits ---
-- Adjust split window sizes proportionally when the terminal window is resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  command = "tabdo wincmd =",
  desc = "Keep splits proportional on terminal resize",
})

-- --- 3. Close Help and Info Panels with 'q' ---
-- Allows exiting read-only panels (help docs, quickfix list) simply by pressing q.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "help", "nofile", "qf", "lspinfo", "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true, desc = "Close helper window" })
  end,
  desc = "Use 'q' to close read-only help/diagnostic buffers",
})
