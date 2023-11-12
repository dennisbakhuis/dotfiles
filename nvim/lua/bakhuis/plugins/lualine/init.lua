return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    -- load lualine config
    -- local lualine_config =  require("bakhuis.plugins.lualine.lualine_config_plain")
    local lualine_config =  require("bakhuis.plugins.lualine.lualine_config_evilline")

    lualine.setup(lualine_config)
  end
}
