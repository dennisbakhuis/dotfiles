-- ------------------------------------
-- Neovim general options
--
-- Author: Dennis Bakhuis 
-- ------------------------------------
vim.api.nvim_exec("language en_US.utf-8", false)

vim.opt.termguicolors = true    -- enable true colors support
vim.opt.guicursor = ""          -- disable cursor blinking
vim.opt.autoread = true         -- auto read when file changes

vim.opt.nu = true               -- show line numbers
vim.opt.relativenumber = true   -- show relative line numbers

vim.opt.tabstop = 4             -- tab width 4 spaces
vim.opt.softtabstop = 4         -- tab width 4 spaces
vim.opt.shiftwidth = 4          -- tab width 4 spaces
vim.opt.expandtab = true        -- use spaces instead of tabs

vim.opt.swapfile = false        -- disable swap files
vim.opt.backup = false          -- disable backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true         -- enable undo files for persistent undo

vim.opt.hlsearch = false        -- disable search highlighting
vim.opt.incsearch = true        -- incremental search

vim.opt.wrap = false            -- disable line wrapping
vim.opt.scrolloff = 8           -- keep 8 lines above and below cursor
vim.opt.signcolumn = "yes"      -- always show sign column
vim.opt.isfname:append("@-@")   -- allow @ in file names

vim.opt.updatetime = 500        -- update interval for CursorHold

vim.opt.colorcolumn = "80"      -- set color column at 80 characters

vim.opt.splitright = true       -- open new split to the right

-- Check in environment variable NEOVIM_PYTHON_ENV exists and set python provider
if os.getenv("NEOVIM_PYTHON_ENV") ~= nil then
    vim.g.python3_host_prog = os.getenv("NEOVIM_PYTHON_ENV")
else
    vim.g.loaded_python3_provider = 0
end

-- disable some providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- disable start new comment on next line after enter
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c","r","o" }
    end,
})

-- Open help in vertical split with max width of 80 characters
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'help',
    callback = function()
        vim.bo.bufhidden = 'unload'
        vim.cmd('wincmd L')
        vim.cmd('vertical resize 80')
    end
})
