-- ====================================================================
-- Neovim Options
-- ====================================================================

local opt = vim.opt

-- Disable unused providers to avoid warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- Appearance
opt.number = true              -- Show line numbers
opt.relativenumber = true      -- Relative line numbers
opt.termguicolors = true       -- True color support
opt.cursorline = true          -- Highlight current line
opt.signcolumn = "yes"         -- Always show sign column
opt.colorcolumn = "80"         -- Show column at 80 characters
opt.showmode = false           -- Don't show mode (statusline shows it)
opt.wrap = false               -- Don't wrap lines
opt.scrolloff = 8              -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8          -- Keep 8 columns left/right of cursor

-- Tabs & Indentation
opt.tabstop = 4                -- Number of spaces tabs count for
opt.shiftwidth = 4             -- Size of an indent
opt.softtabstop = 4            -- Number of spaces per tab when editing
opt.expandtab = true           -- Use spaces instead of tabs
opt.smartindent = true         -- Smart autoindenting
opt.autoindent = true          -- Copy indent from current line

-- Search
opt.ignorecase = true          -- Case insensitive search
opt.smartcase = true           -- Case sensitive if uppercase in search
opt.hlsearch = true            -- Highlight search results
opt.incsearch = true           -- Show search matches as you type

-- Behavior
opt.mouse = "a"                -- Enable mouse support
opt.clipboard = "unnamedplus"  -- Use system clipboard
opt.undofile = true            -- Persistent undo

-- Clipboard provider (isomorphic_copy for SSH support)
-- This enables clipboard operations to work seamlessly over SSH
local isomorphic_copy_path = vim.fn.expand("~/.tools/isomorphic_copy")
if vim.fn.isdirectory(isomorphic_copy_path) == 1 then
  vim.g.clipboard = {
    name = "isomorphic_copy",
    copy = {
      ["+"] = { isomorphic_copy_path .. "/bin/c" },
      ["*"] = { isomorphic_copy_path .. "/bin/c" },
    },
    paste = {
      ["+"] = { isomorphic_copy_path .. "/bin/p" },
      ["*"] = { isomorphic_copy_path .. "/bin/p" },
    },
    cache_enabled = 0,
  }
end
opt.backup = false             -- Don't create backup files
opt.writebackup = false        -- Don't create backup before overwriting
opt.swapfile = false           -- Don't use swap files
opt.updatetime = 250           -- Faster completion (default 4000ms)
opt.timeoutlen = 300           -- Time to wait for mapped sequence
opt.splitright = true          -- Vertical split to the right
opt.splitbelow = true          -- Horizontal split below
opt.confirm = true             -- Confirm to save changes before exiting
opt.completeopt = "menuone,noselect" -- Completion options

-- Folding
opt.foldmethod = "indent"      -- Fold based on indent
opt.foldlevelstart = 99        -- Start with all folds open

-- Whitespace characters
opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "»",
  precedes = "«",
}

-- Command line
opt.wildmode = "longest:full,full" -- Command line completion mode
opt.pumheight = 10             -- Max items in popup menu

-- Spell checking
opt.spelllang = "en_us"
opt.spell = false              -- Disabled by default, enable per filetype

-- Performance
opt.lazyredraw = true          -- Don't redraw while executing macros