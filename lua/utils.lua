local M = {}

M.border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
}

local update_border = function()
    local orig_floating_preview = vim.lsp.util.open_floating_preview

    ---@diagnostic disable-next-line: duplicate-set-field
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or M.border
        return orig_floating_preview(contents, syntax, opts, ...)
    end
end

M.LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" }

M.isNix = vim.g.nix == true
M.isNotNix = vim.g.nix == nil

function M.set(nonNix, nix)
    if M.isNix then
        return nix
    else
        return nonNix
    end
end

function M.is_loaded(name)
    local Config = require("lazy.core.config")
    return Config.plugins[name] and Config.plugins[name]._.loaded
end

function M.on_attach(client, bufnr)
    update_border()

    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- Supports
    local supp = function(method)
        return client:supports_method(method)
    end

    -- Conditional normal map
    local cnmap = function(method, keys, func, desc)
        if supp(method) then
            nmap(keys, func, desc)
        end
    end

    cnmap("textDocument/hover", "K", vim.lsp.buf.hover, "Hover Docs")
    cnmap("textDocument/definition", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    cnmap("textDocument/declaration", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    cnmap("textDocument/implementation", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    cnmap("textDocument/typeDefinition", "<leader>de", vim.lsp.buf.type_definition, "[T]ype [D]efinition")
    cnmap("textDocument/rename", "<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
    cnmap("textDocument/codeAction", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    vim.lsp.inlay_hint.enable(false)

    -- local inlay_hints_group = vim.api.nvim_create_augroup("LSP_inlayHints", { clear = false })
    -- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    --     group = inlay_hints_group,
    --     desc = "Update inlay hints on line change",
    --     buffer = bufnr,
    --     callback = function()
    --         vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    --     end,
    -- })
end

return M
