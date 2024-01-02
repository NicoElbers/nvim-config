return {
	"nvimtools/none-ls.nvim",
	lazy = false,
	config = function()
		local none_ls = require("null-ls")
		none_ls.setup({
			sources = {
				-- Formatting
				none_ls.builtins.formatting.stylua,
				none_ls.builtins.formatting.prettierd,
				none_ls.builtins.formatting.black,
				none_ls.builtins.formatting.isort,

				-- Diagnostics
				none_ls.builtins.diagnostics.eslint_d,
			},
		})

		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
	end,
}
