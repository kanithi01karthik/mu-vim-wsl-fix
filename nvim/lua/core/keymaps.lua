-- =============================================================================
--                                GLOBAL KEYMAPS
-- =============================================================================
-- This file defines general keymaps for editor navigation, window management,
-- and buffer manipulation. Note that plugin-specific keymaps are defined in
-- their respective plugin files (in lua/plugins/).
--
-- Every keymap here includes a `desc` field, which is read by `which-key.nvim`
-- to show a helpful cheat sheet when you press the leader key (Space).
-- =============================================================================

-- Helper function to make keymap definition cleaner
local keymap = vim.keymap.set
local opts = { silent = true }

-- --- 1. General Keymaps ---

-- Clear search highlights
keymap("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlight", silent = true })

-- Save file easily
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file", silent = true })
keymap("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file (insert mode)", silent = true })
keymap("n", "<C-s>", ":w<CR>", { desc = "Save file (normal mode)", silent = true })

-- Quit Neovim
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit current window", silent = true })
keymap("n", "<leader>Q", ":qa<CR>", { desc = "Quit Neovim (all windows)", silent = true })

-- --- 2. Window Splitting & Management ---
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically", silent = true })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally", silent = true })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size", silent = true })
keymap("n", "<leader>sx", ":close<CR>", { desc = "Close current split", silent = true })

-- --- 3. Split Window Navigation (IDE-style Ctrl+hjkl) ---
-- Moves cursor to the split in the specified direction.
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window split", silent = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to bottom window split", silent = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to top window split", silent = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window split", silent = true })

-- --- 4. Buffer Navigation ---
-- Think of buffers as open tabs in a browser/VS Code.
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Go to previous buffer", silent = true })
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Go to next buffer", silent = true })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete/Close current buffer", silent = true })

-- --- 5. Visual Mode Indentation ---
-- Stay in visual mode after indenting/outdent blocks of code.
keymap("v", "<", "<gv", { desc = "Indent block left", silent = true })
keymap("v", ">", ">gv", { desc = "Indent block right", silent = true })

-- --- 6. Move Code Lines Up/Down ---
-- Alt+j / Alt+k in visual or visual-block mode moves selected blocks up/down.
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down", silent = true })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up", silent = true })

-- --- 7. Terminal Mode Navigation ---
-- Allows escaping terminal mode with double-escape, which is much more intuitive.
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", silent = true })

-- --- 8. Code Runner ---
keymap("n", "<leader>rr", "<cmd>w<CR><cmd>RunCode<CR>", { desc = "Save and run code" })
keymap("n", "<leader>rt", function()
  if _G.toggle_code_runner_mode then
    _G.toggle_code_runner_mode()
  else
    vim.notify("Code Runner is not initialized yet", vim.log.levels.WARN)
  end
end, { silent = true, desc = "Toggle Code Runner mode" })

