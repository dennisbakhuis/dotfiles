return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    cmd = "ToggleTerm",
    keys = {
      { "<C-_>", ":ToggleTerm<CR>" },
      { "<C-/>", ":ToggleTerm<CR>" },
      { "<leader>th", ":ToggleTerm direction=horizontal<CR>" },
      { "<leader>tv", ":ToggleTerm direction=vertical<CR>" },
    },
    opts = {
      -- size can be a number or function which is passed the current terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-_>]],
      hide_numbers = true,
    },
  },
}
