return {
	"bluz71/vim-nightfly-guicolors",
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme nightfly]])

        -- Make Window separator bg transparent
        vim.cmd([[highlight WinSeparator guibg=None ]])
	end,
}
