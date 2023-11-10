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
    },
}
