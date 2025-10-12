-- ====================================================================
-- Neovim Keymaps
-- ====================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader is set to <Space> in init.lua

-- ====================================================================
-- General
-- ====================================================================

-- Better escape
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Clear search highlights
keymap("n", "<Esc>", ":noh<CR>", opts)

-- Save file
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Quit
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

-- ====================================================================
-- Navigation
-- ====================================================================

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- ====================================================================
-- Editing
-- ====================================================================

-- Better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Stay in visual mode after indent
keymap("v", "<Tab>", ">gv", opts)
keymap("v", "<S-Tab>", "<gv", opts)

-- Paste without yanking
keymap("v", "p", '"_dP', opts)

-- Delete without yanking
keymap("n", "<leader>d", '"_d', { desc = "Delete without yank" })
keymap("v", "<leader>d", '"_d', { desc = "Delete without yank" })

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- ====================================================================
-- Splits & Tabs
-- ====================================================================

-- Split windows
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- Tabs
keymap("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })
keymap("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" })
keymap("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" })

-- ====================================================================
-- Terminal
-- ====================================================================

-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", opts)

-- Terminal escape
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Open terminal
keymap("n", "<leader>tt", ":terminal<CR>", { desc = "Open terminal" })

-- ====================================================================
-- File Explorer (Netrw)
-- ====================================================================

keymap("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })