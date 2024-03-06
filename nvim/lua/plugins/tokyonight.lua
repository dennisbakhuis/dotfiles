return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      -- styles = {
      --   sidebars = "transparent",
      --   floats = "transparent",
      -- },
    },
    config = function()
      vim.g.tokyonight_style = "night"
      require("tokyonight").setup({
        -- other configs
        on_colors = function(colors)
          colors.border = "#565f89"
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
