local utils = require("utils")

return {
    "nvimtools/none-ls.nvim",
    lazy = false,
    config = function()
        local none_ls = require("null-ls")
        local bi = none_ls.builtins
        none_ls.setup({
            defaults = {
                update_in_insert = true,
            },
            sources = {
                -- -- Formatting
                -- bi.formatting.stylua,
                -- bi.formatting.prettier.with({
                --     extra_filetypes = { "javascript", "typescript", "css", "html", "json", "jsonc", "yaml", "markdown" },
                --     extra_args = function(params)
                --         return {
                --             "--config-precedence",
                --             "--tab-width",
                --             "4",
                --             "--print-width",
                --             "80",
                --         }
                --     end,
                -- }),
                -- bi.formatting.black,
                -- bi.formatting.isort,

                -- Diagnostics
                bi.diagnostics.checkstyle.with({
                    extra_args = { "-c", "/checkstyle.xml" },
                }),

                bi.diagnostics.eslint_d.with({
                    extra_args = function(params)
                        local file_types = { "js", "cjs", "yaml", "yml", "json" }
                        for _, file_type in pairs(file_types) do
                            local f = io.open(params.root .. "/.eslintrc." .. file_type)
                            if f ~= nil then
                                io.close(f)
                                return {} -- If a config exists, do nothing
                            end
                        end
                        return {
                            "--config",
                            vim.fs.normalize("~/.config/default_configs/.eslintrc.js"),
                        }
                    end,
                }),
                bi.diagnostics.ltrs.with({
                    diagnostic_config = {
                        underline = true,
                        virtual_text = false,
                        signs = true,
                        update_in_insert = true,
                    },
                }),

                -- Code actions
                bi.code_actions.eslint_d,
                bi.code_actions.ltrs,
            },
            on_attach = utils.on_attach,
        })
    end,
}
