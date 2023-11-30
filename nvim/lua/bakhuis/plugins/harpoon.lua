return {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>hm", function() require("harpoon.mark").add_file() end, desc = "Mark file with Harpoon" },
        { "<leader>hu", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle Harpoon quick menu" },
        { "<leader>hn", function() require("harpoon.ui").nav_next() end, desc = "Next Harpoon mark" },
        { "<leader>hp", function() require("harpoon.ui").nav_prev() end, desc = "Previous Harpoon mark" },
        { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon mark 1" },
        { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon mark 2" },
        { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon mark 3" },
        { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon mark 4" },
        { "<leader>5", function() require("harpoon.ui").nav_file(5) end, desc = "Harpoon mark 5" },
        { "<leader>6", function() require("harpoon.ui").nav_file(6) end, desc = "Harpoon mark 6" },
    },
    config = function()
        require("harpoon").setup({
            tabline = false,
        })
    end,
}
