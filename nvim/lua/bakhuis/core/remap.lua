-- ------------------------------------
-- Neovim key mappings
--
-- Author: Dennis Bakhuis 
-- ------------------------------------

-- Map leader key to space
vim.g.mapleader = " "

-- Make move page up/down keep cursor in place
vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc = "Move page up"})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc = "Move page down"})

-- Keep search terms in middle of screen
vim.keymap.set("n", "n", "nzzzv", {desc = "Search next"})
vim.keymap.set("n", "N", "Nzzzv", {desc = "Search previous"})

-- yank to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", '"+y', {desc = "Yank to system clipboard"})
vim.keymap.set({"n", "v"}, "<leader>Y", '"+Y', {desc = "Yank to system clipboard"})

-- turn off annoying Q
vim.keymap.set("n", "Q", "<nop>", {desc = "Turn off Q"})

