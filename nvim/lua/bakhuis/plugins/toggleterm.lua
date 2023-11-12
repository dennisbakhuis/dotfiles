return   {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {},
    config = function()
        require("toggleterm").setup {
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<leader>tt]],
            start_in_insert = true,
            insert_mappings = false,
            persist_size = true,
            direction = "horizontal",
        }

        -------------------------
        -- additional keybindings
        -------------------------

        -- open a vertical terminal if new
        vim.keymap.set('n', '<leader>tv', [[<Cmd>ToggleTerm direction=vertical<CR>]], {})

        -- open a horizontal terminal if new
        vim.keymap.set('n', '<leader>th', [[<Cmd>ToggleTerm direction=horizontal<CR>]], {})

        -- move to other windows
        vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], {noremap = true})
        vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], {noremap = true})
        vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], {noremap = true})
        vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], {noremap = true})

        -- copy to clipboard
        vim.keymap.set('t', '<C-y>', [[<C-\><C-n>"+yi]], {noremap = true})

        -- paste from clipboard
        vim.keymap.set('t', '<C-p>', [[<C-\><C-n>"+pi]], {noremap = true})
    end,
}
