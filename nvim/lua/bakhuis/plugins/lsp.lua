return {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v3.x',
    	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/nvim-cmp',
		'L3MON4D3/LuaSnip',
    	},
	config = function()
		local lsp_zero = require('lsp-zero')

		lsp_zero.on_attach(function(client, bufnr)
			local opts = {buffer = bufnr, remap = false}

			vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
			vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
			vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
			vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
			vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.rename() end, opts)

            -- Not sure what this is for or not missed yet
			-- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
			-- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
			-- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
			-- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
			-- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
		end)

		require('mason').setup({})
		require('mason-lspconfig').setup({
			ensure_installed = {
				"pyright",
				"lua_ls",
                "bashls",
                "taplo",
                "yamlls",
                "dockerls",
                "jsonls",
                "vimls",
                "marksman",
			},
			handlers = {
				lsp_zero.default_setup,
				lua_ls = function()
					local lua_opts = lsp_zero.nvim_lua_ls()
					require('lspconfig').lua_ls.setup(lua_opts)
				end,
			},
		})

		local cmp = require('cmp')
		local cmp_select = {behavior = cmp.SelectBehavior.Select}

		cmp.setup({
			sources = {
				{name = 'path'},
				{name = 'nvim_lsp'},
				{name = 'nvim_lua'},
			},
			formatting = lsp_zero.cmp_format(),
			mapping = cmp.mapping.preset.insert({
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				['<C-y>'] = cmp.mapping.confirm({ select = true }),
				['<C-Space>'] = cmp.mapping.complete(),
			}),
		})

        -- make zsh files recognized as sh for bash-ls & treesitter
        vim.filetype.add {
            extension = {
                zsh = "sh",
                sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
            },
            filename = {
                [".zshrc"] = "sh",
                [".zshenv"] = "sh",
            },
        }
	end,
}
