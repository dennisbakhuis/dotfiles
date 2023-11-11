return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        },
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-web-devicons",
    },
    config = function()
        -- Setup up telescope key-bindings
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set("n", "<leader>fc", builtin.grep_string)
        vim.keymap.set('n', '<leader>fg', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        -- Setup up telescope general including extensions
        local actions = require('telescope.actions')
        local telescope = require('telescope')

        telescope.setup {
            pickers = {
                find_files = {
                    hidden = true,
                    follow = true,
                    no_ignore = false,
                    find_command = { 'fd', '--hidden', '--type', 'f' },
                },
            },
            defaults = {
                path_display = { "truncate " },
                mappings = {
                    i = {
                        ["<C-p>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-n>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
                prompt_prefix = '🔍 ',
                color_devicons = true,
            },
        }
        telescope.load_extension('fzf')
        telescope.load_extension("file_browser")

        -- keymap for open file_browser
        vim.api.nvim_set_keymap(
            "n",
            "<space>ee",
            ":Telescope file_browser<CR>",
            { noremap = true }
        )

        -- keymap for open file_browser with current file path
        vim.api.nvim_set_keymap(
            "n",
            "<space>ec",
            ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
            { noremap = true }
        )
    end,
}
