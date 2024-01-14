return {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v3.x',
    dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
		'L3MON4D3/LuaSnip',
        "zbirenbaum/copilot-cmp",
        "zbirenbaum/copilot.lua",
        "onsails/lspkind.nvim",
        "simrat39/rust-tools.nvim",
    },
	config = function()
		local lsp_zero = require('lsp-zero')

		lsp_zero.on_attach(function(_, bufnr)
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
                "rust_analyzer",
			},
			handlers = {
				lsp_zero.default_setup,
				lua_ls = function()
					local lua_opts = lsp_zero.nvim_lua_ls()
					require('lspconfig').lua_ls.setup(lua_opts)
				end,
                rust_analyzer = function()
                    local rust_tools = require('rust-tools')
                    rust_tools.setup({
                        server = {
                            on_attach = function(_, bufnr)
                                vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
                            end,
                            settings = {
                                ['rust-analyzer'] = {
                                    imports = {
                                        granularity = {
                                            group = "module",
                                        },
                                        prefix = "self",
                                    },
                                    cargo = {
                                        features = { "ssr" },
                                        loadOutDirsFromCheck = true,
                                        buildScripts = {
                                            enable = true,
                                        }
                                    },
                                    check = {
                                        features = { "ssr" },
                                    },
                                    -- Add clippy lints for Rust.
                                    checkOnSave = {
                                        features = { "ssr" },
                                        command = "clippy",
                                        extraArgs = { "--no-deps" },
                                    },
                                    procMacro = {
                                        enable = false,
                                    },
                                }, -- rust-analyzer options
                            }

                        }
                    })
                end,
			},
		})

        require('copilot').setup({
            suggestion = {enabled = false},
            panel = {enabled = false},
        })
        require('copilot_cmp').setup({
                event = { "InsertEnter", "LspAttach" },
                fix_pairs = true,
        })

		local cmp = require('cmp')
		local cmp_select = {behavior = cmp.SelectBehavior.Select}
        local cmp_action = require('lsp-zero').cmp_action()

        -- Function for tab completion as recommended by copilot-cmp
        local has_words_before = function()
            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
        end

		cmp.setup({
			sources = {
                {name = 'copilot', group_index = 1 },
                -- other sources
				{name = 'path', group_index = 2 },
				{name = 'nvim_lsp', group_index = 3},
				{name = 'nvim_lua', group_index = 3 },
                {name = 'buffer', group_index = 3 },
			},
			formatting = {
                fields = {'abbr', 'kind', 'menu'},
                format = require('lspkind').cmp_format({
                    mode = 'symbol',
                    maxwidth = 50,
                    ellipsis_char = '…',
                    symbol_map = { Copilot = "" },
                })
            },
			mapping = cmp.mapping.preset.insert({
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				['<C-y>'] = cmp.mapping.confirm({ select = true }),
				['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({
                    -- documentation says this is important.
                    -- I don't know why.
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),
                ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                -- ['<Tab>'] = cmp_action.tab_complete(),
                ["<Tab>"] = vim.schedule_wrap(function(fallback)
                    if cmp.visible() and has_words_before() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end),

                ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
                ['<C-e>'] = cmp.mapping.close(),
			}),
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
		})

        -- add highlighting for copilot
        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})

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
