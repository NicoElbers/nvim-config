return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            auto_install = true,
            ensure_installed = {},
            ignore_install = {},
            sync_install = true,
            modules = {},
            highlight = {
                enable = true,
                disable = { "latex" },
            },
            indent = { enable = true },
        })
    end,
}
