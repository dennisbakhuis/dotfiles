return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            highlight = {
                enable = true,
            },
            indent = { enable = true },
            ensure_installed = {
                "json",
                "yaml",
                "toml",
                "markdown",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "python",
            },
        })
    end,
}
