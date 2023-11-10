return {
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        keys = {
            { "<leader>dc", function() require("dap").continue() end, desc = "Debug continue" },
            { "<leader>dso", function() require("dap").step_over() end, desc = "Debug step over" },
            { "<leader>dsi", function() require("dap").step_into() end, desc = "Debug step into" },
            { "<leader>dst", function() require("dap").step_out() end, desc = "Debug step out" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug toggle breakpoint" },
        },
    },
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require("dap-python").setup("/Users/dennis/miniconda3/envs/vim/bin/python")
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        requires = {
            "mfussenegger/nvim-dap",
        },
        keys = {
            { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },
        lazy = false,
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup(opts)

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
        end,
    },
}
