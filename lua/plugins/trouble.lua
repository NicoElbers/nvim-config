return {
    "folke/trouble.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        icons = true,
    },
    config = function(opts)
        require("trouble").setup(opts)
    end,
    keys = {
        {
            "<leader>td",
            function()
                require("trouble").toggle()
            end,
        },
        {
            "<C-j>",
            function()
                require("trouble").open("workspace_diagnostics")
                require("trouble").next({ skip_groups = true, jump = true })
            end,
        },
        {
            "<C-k>",
            function()
                require("trouble").open("workspace_diagnostics")
                require("trouble").previous({ skip_groups = true, jump = true })
            end,
        },
    },
}
