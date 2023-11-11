return {
	"mbbill/undotree",
    keys = {
        { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
    },
	config = function()
	    vim.g.undotree_WindowLayout = 3
	    vim.g.undotree_SetFocusWhenToggle = 1
	end,
}
