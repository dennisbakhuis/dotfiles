-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set clipboard to isomorphic copy if ISOMORPHIC_COPY is set
if os.getenv("ISOMORPHIC_COPY") ~= nil then
  vim.g.clipboard = {
    name = 'isomorphic_copy',
    copy = { ['+'] = 'c', ['*'] = 'c' },
  }
end

-- let g:clipboard = {
--       \   'name': 'myClipboard',
--       \   'copy': {
--       \      '+': ['tmux', 'load-buffer', '-'],
--       \      '*': ['tmux', 'load-buffer', '-'],
--       \    },
--       \   'paste': {
--       \      '+': ['tmux', 'save-buffer', '-'],
--       \      '*': ['tmux', 'save-buffer', '-'],
--       \   },
--       \   'cache_enabled': 1,
--       \ }
