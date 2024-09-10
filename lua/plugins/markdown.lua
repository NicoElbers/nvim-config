local utils = require("utils")

return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = utils.set(function()
            vim.fn["mkdp#util#install"]()
        end),
    },
    {
        "OXY2DEV/markview.nvim",
        ft = "markdown",

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
}
