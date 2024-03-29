local utils = require("utils")

local servers = {
    lua_ls = {},
    -- NOTE: rust analyzer is done through the rustaceanvim plugin
    --
    -- rust_analyzer = {},
    tsserver = {},
    html = {},
    cssls = {},
    emmet_ls = {},
    tailwindcss = {},
    eslint = {},
    clangd = {},
    zls = {},
    asm_lsp = {},
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
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        enabled = true,
        version = "^4",
        ft = { "rust" },
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    on_attach = utils.on_attach,
                    default_settings = {
                        ["rust_analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                            },
                            -- Add clippy lints for Rust
                            checkOnSave = {
                                allFeatures = true,
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
                                    -- Removing annoying lints I'm never doing
                                    "-Aclippy::suboptimal_flops",
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
