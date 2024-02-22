return {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    config = function(_, opts)
        require("sniprun").setup(opts)

        -- vim.keymap.set({ "n" }, "<C-r>", "<cmd>SnipRun<cr>")
        -- vim.keymap.set({ "v" }, "<C-r>", "<cmd>'<,'>SnipRun<cr>")
    end,
}
