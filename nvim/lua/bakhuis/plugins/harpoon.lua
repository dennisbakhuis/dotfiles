return {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
	local mark = require("harpoon.mark")
	local ui = require("harpoon.ui")

	vim.keymap.set(
		"n",
		"<leader>hm",
 		mark.add_file,
		{ desc = "Mark file with harpoon" }
	)
	vim.keymap.set(
		"n",
		"<leader>hu",
		ui.toggle_quick_menu,
		{ desc = "Toggle Harpoon quick menu" }
	)
	vim.keymap.set(
		"n",
		"<leader>hn",
		ui.nav_next,
		{ desc = "Go to next harpoon mark" }
	)
	vim.keymap.set(
		"n",
		"<leader>hp",
		ui.nav_prev,
		{ desc = "Go to previous harpoon mark" }
	)
    end,
}
