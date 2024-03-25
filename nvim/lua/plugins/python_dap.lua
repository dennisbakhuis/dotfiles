return {
  {
    "mfussenegger/nvim-dap",
    -- version = "*",
    keys = {
      {
        "<leader>da",
        function()
          if vim.fn.filereadable(".vscode/launch.json") then
            require("dap.ext.vscode").load_launchjs(".vscode/launch.json", { debugpy = { "python" } })
          end
          require("dap").continue()
        end,
        desc = "Run with Args",
      },
    },
    config = function() end,
  },
  -- {
  --   "mfussenegger/nvim-dap-python",
  --   version = "*",
  -- },
}
