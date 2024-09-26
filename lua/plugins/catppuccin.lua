return {
    "catppuccin/nvim",
    priority = 1000,
    config = function()
        -- colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
        require("catppuccin").setup({
            transparent_background = true,
        })
        vim.cmd.colorscheme("catppuccin-mocha")
    end,
}
