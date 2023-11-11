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
            insert_mappings = true,
            persist_size = true,
            direction = "horizontal",
        }
    end,
}
