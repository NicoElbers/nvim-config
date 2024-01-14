local M = {}

function M.on_attach(client, bufnr)
	-- Normal map
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	-- Supports
	local supp = function(method)
		return client.supports_method(method)
	end

	-- Conditional normal map
	local cnmap = function(method, keys, func, desc)
		if supp(method) then
			nmap(keys, func, desc)
		end
	end

	if supp("textDocument/formatting") then
		vim.api.nvim_create_augroup("none_ls_group", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = "none_ls_group",
			buffer = bufnr,
			callback = function() end,
			vim.lsp.buf.format({ bufnr = bufnr }),
		})

		nmap("<leader>f", vim.lsp.buf.format, "[F]ormat")
	end

	cnmap("textDocument/hover", "K", vim.lsp.buf.hover, "Hover Docs")
	cnmap("textDocument/definition", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	cnmap("textDocument/declaration", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	cnmap("textDocument/implementation", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	cnmap("textDocument/typeDefinition", "<leader>td", vim.lsp.buf.type_definition, "[T]ype [D]efinition")
	cnmap("textDocument/rename", "<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
	cnmap("textDocument/codeAction", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	-- cnmap("textDocument/signatureHelp", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	if supp("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(bufnr, true)
	end
end

return M
