return {
    "catppuccin/nvim",
    name = "catppuccin",

    opts = {
        flavour = "mocha",
        transparent_background = true,
        integrations = {
            gitsigns = true,
            indent_blankline = { enabled = true },
            lsp_trouble = true,
            markdown = true,
            blink_cmp = true,
            native_lsp = {
                enabled = true,
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
            },
            neotree = true,
            semantic_tokens = true,
            telescope = true,
            treesitter = true,
            treesitter_context = true,
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
    end,
}
