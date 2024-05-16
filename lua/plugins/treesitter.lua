return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            auto_install = true,
            ensure_installed = { "lua", "rust", "c", "zig" },
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
