local utils = require("utils")

local servers = {
    lua_ls = {},
    rust_analyzer = nil,
    tsserver = {},
    html = {},
    cssls = {},
    emmet_ls = {},
    tailwindcss = {},
    eslint = {},
    clangd = {},
    zls = nil,
    -- zls = {
    --     warn_style = true,
    -- },
    marksman = {},
    pyright = {},
}

return {
    {
        "j-hui/fidget.nvim",
        event = { "BufRead", "BufWrite", "BufNewFile" },
        tag = "legacy",
        opts = {},
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/neodev.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("neodev").setup()

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            capabilities.document_formatting = false

            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    -- Assure that I actually configure the table in servers
                    if servers[server_name] == nil then
                        return
                    end

                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = utils.on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    })
                end,
            })

            require("lspconfig").zls.setup({
                capabilities = capabilities,
                on_attach = utils.on_attach,
                settings = {
                    warn_style = true,
                },
            })
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        lazy = false, -- This plugin is already lazy
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
