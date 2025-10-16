-- Lsp, but better :D

local M = {}

function M.setup()
    local utils = require("utils")
    local capabilities = require("blink.cmp").get_lsp_capabilities({}, true)

    local base_config = {
        on_attach = utils.on_attach,
        capabilities = capabilities,
        root_markers = { ".git" }, -- A sensible default for finding project root
    }

    -- Central table of all language servers to set up
    local servers = {
        clangd = { filetypes = { "c", "cpp" }, cmd = { "clangd" } },
        lua_ls = {
            filetypes = { "lua" },
            cmd = { "lua-language-server" },
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
                    diagnostics = { globals = { "vim" } },
                    workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        },
        marksman = { filetypes = { "markdown" }, cmd = { "marksman" } },
        nixd = { filetypes = { "nix" }, cmd = { "nixd" } },
        pyright = { filetypes = { "python" } },
        ts_ls = { filetypes = { "typescript", "javascript", "html" } },
        superhtml = { filetypes = { "html" } },
        emmet_language_server = { filetypes = { "html" } },
        tailwindcss = {
            filetypes = { "css", "typescriptreact", "javascriptreact", "html" },
            cmd = { "tailwindcss-language-server" },
        },
        zls = { filetypes = { "zig" }, cmd = { "zls" }, settings = { warn_style = true } },
        gopls = { filetypes = { "go" }, cmd = { "gopls" } },
        vhdl_ls = { filetypes = { "vhdl", "vdh" }, cmd = { "vhdl_ls" } },
    }

    -- Loop through the servers table and set them up
    for server_name, config in pairs(servers) do
        local final_config = vim.tbl_deep_extend("force", base_config, config)
        vim.lsp.config[server_name] = final_config
        vim.lsp.enable(server_name)
    end

    -- Configure fidget.nvim for LSP progress UI
    require("fidget").setup({})
end

return M
