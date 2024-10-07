return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "debugloop/telescope-undo.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        cmd = "Telescope",
        keys = {
            { "<leader>f", "<cmd>Telescope find_files<cr>" },
            { "<leader>ls", "<cmd>Telescope live_grep<cr>" },
            { "<leader>bs", "<cmd>Telescope current_buffer_fuzzy_find<cr>" },
            { "gr", "<cmd>Telescope lsp_references<cr>" },
        },
        config = function()
            local telescope = require("telescope")
            local previewers = require("telescope.previewers")
            local utils = require("telescope.previewers.utils")
            local pfiletype = require("plenary.filetype")

            local new_maker = function(filepath, bufnr, opts)
                opts = opts or {}
                if opts.use_ft_detect == nil then
                    local ft = pfiletype.detect(filepath)
                    opts.use_ft_detect = false

                    if ft == "zig" then
                        utils.regex_highlighter(bufnr, ft)
                    end
                end

                previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end

            telescope.setup({
                defaults = {
                    buffer_previewer_maker = new_maker,
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                    undo = {},
                },
            })

            telescope.load_extension("ui-select")
            telescope.load_extension("undo")
        end,
    },
}
