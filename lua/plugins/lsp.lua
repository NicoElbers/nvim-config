local utils = require("utils")

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/neodev.nvim",
            "j-hui/fidget.nvim",
        },
        ft = {
            "c",
            "cpp",
            "lua",
            "markdown",
            "nix",
            "python",
            "html",
            "css",
            "javascript",
            "typescript",
            "zig",
            "vhd",
            "vhdl",
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            capabilities.document_formatting = false

            local lspconfig = require("lspconfig")

            local function setup_autocmd(name, lang, opts)
                local ft = vim.bo.filetype

                if type(lang) == "string" then
                    if lang == ft then
                        lspconfig[name].setup(opts)
                        return
                    end
                elseif type(lang) == "table" then
                    for _, v in ipairs(lang) do
                        if v == ft then
                            lspconfig[name].setup(opts)
                            return
                        end
                    end
                end

                vim.api.nvim_create_autocmd("FileType", {
                    pattern = lang,
                    callback = function()
                        lspconfig[name].setup(opts)
                    end,
                })
            end

            setup_autocmd("clangd", { "c", "cpp" }, {
                on_attach = utils.on_attach,
                cmd = { "clangd" },
                capabilities = capabilities,
            })

            -- Lua
            setup_autocmd("lua_ls", "lua", {
                on_attach = utils.on_attach,
                cmd = { "lua-language-server" },
                capabilities = capabilities,
            })

            -- Markdown
            setup_autocmd("marksman", "markdown", {
                on_attach = utils.on_attach,
                cmd = { "marksman" },
                capabilities = capabilities,
            })
            -- Nix
            setup_autocmd("nixd", "nix", {
                on_attach = utils.on_attach,
                cmd = { "nixd" },
                capabilities = capabilities,
            })

            -- Python
            setup_autocmd("pyright", "python", {
                on_attach = utils.on_attach,
                cmd = { "pyright-langserver" },
                capabilities = capabilities,
            })

            -- Web
            setup_autocmd("tsserver", { "typescript", "javascript", "html" }, {
                on_attach = utils.on_attach,
                capabilities = capabilities,
            })

            setup_autocmd("html", "html", {
                on_attach = utils.on_attach,
                capabilities = capabilities,
            })

            setup_autocmd("emmet_language_server", "html", {
                on_attach = utils.on_attach,
                cmd = { "emmet-language-server" },
                capabilities = capabilities,
            })

            setup_autocmd("tailwindcss", "css", {
                on_attach = utils.on_attach,
                cmd = { "tailwindcss-language-server" },
                capabilities = capabilities,
            })

            -- Zig
            setup_autocmd("zls", "zig", {
                capabilities = capabilities,
                cmd = { "zls" },
                on_attach = utils.on_attach,
                settings = {
                    warn_style = true,
                },
            })

            -- Go
            setup_autocmd("gopls", "go", {
                on_attach = utils.on_attach,
                cmd = { "gopls" },
                capabilities = capabilities,
            })

            -- VHDL
            setup_autocmd("vhdl_ls", { "vhdl", "vdh" }, {
                on_attach = utils.on_attach,
                cmd = { "vhdl_ls" },
                capabilities = capabilities,
            })
        end,
    },
    -- Rust
    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
        init = function()
            vim.g.rustaceanvim = {
                tools = {
                    enable_clippy = true,
                },
                server = {
                    on_attach = utils.on_attach,
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                features = "all",
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                            },
                            -- Add clippy lints for Rust
                            checkOnSave = {
                                allFeatures = true,
                                allTargets = true,
                                command = "clippy",
                                extraArgs = {
                                    "--",
                                    "--no-deps",
                                    "-Dclippy::pedantic",
                                    "-Dclippy::nursery",
                                    "-Dclippy::unwrap_used",
                                    "-Dclippy::enum_glob_use",
                                    "-Wclippy::complexity",
                                    "-Wclippy::perf",
                                    -- Shitty lints imo
                                    "-Aclippy::module_name_repetitions",
                                },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = { "async_trait" },
                                    ["napi-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                },
                            },
                        },
                    },
                },
            }
        end,
    },
}
