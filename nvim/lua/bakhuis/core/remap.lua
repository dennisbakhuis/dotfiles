-- ------------------------------------
-- Neovim key mappings
--
-- Author: Dennis Bakhuis 
-- ------------------------------------

-- Map leader key to space
vim.g.mapleader = " "

-- Map file explorer to leader + e
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

