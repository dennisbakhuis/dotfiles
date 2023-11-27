return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        require('dashboard').setup(
            { config = {
                week_header = { enable = true },
                shortcut = {
                    { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                    {
                        icon = ' ',
                        icon_hl = '@variable',
                        desc = 'files',
                        group = 'Label',
                        action = 'Telescope find_files',
                        key = 'f',
                    },
                    {
                        icon = '⚙  ',
                        desc = 'dotfiles',
                        group = '@property',
                        action = 'execute "cd $HOME/dotfiles" | Telescope find_files',
                        key = 'd',
                    },
                    {
                        icon = '✕ ',
                        desc = 'quit',
                        group = '@property',
                        action = 'quitall',
                        key = 'q',
                    },
                },
                footer = { '  ' .. vim.fn.getcwd(), },
            },
        })
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
