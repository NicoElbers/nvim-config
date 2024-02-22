return {
    "mbbill/undotree",
    lazy = false,
    config = function()
        vim.keymap.set("n", "<leader>u", function()
            vim.cmd.UndotreeToggle()
            vim.cmd.UndotreeFocus()
        end)
    end,
}
