return {
	lua_ls = {},
	-- NOTE: rust analyzer is done through the rust tools plugin
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
			-- UI thingies
			local border = {
				{ "╭", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╮", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "╯", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╰", "FloatBorder" },
				{ "│", "FloatBorder" },
			}
			local orig_floating_preview = vim.lsp.util.open_floating_preview
			---@diagnostic disable-next-line: duplicate-set-field
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or border
				return orig_floating_preview(contents, syntax, opts, ...)
			end

			require("neodev").setup()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = utils.on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
					})
				end,
			})
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = true,
				underline = true,
				severity_sort = false,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
	},
	{
		"simrat39/rust-tools.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			-- UI thingies
			local border = {
				{ "╭", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╮", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "╯", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╰", "FloatBorder" },
				{ "│", "FloatBorder" },
			}
			local orig_floating_preview = vim.lsp.util.open_floating_preview
			---@diagnostic disable-next-line: duplicate-set-field
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or border
				return orig_floating_preview(contents, syntax, opts, ...)
			end

			-- local mason_registry = require("mason-registry")
			-- local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
			-- local codelldb_path = codelldb_root .. "adapter/codelldb"
			-- local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
			local rt = require("rust-tools")
			rt.setup({
				server = {
					on_attach = utils.on_attach,
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								runBuildScripts = true,
							},
							-- Add clippy lints for Rust.
							checkOnSave = {
								allFeatures = true,
								command = "clippy",
								extraArgs = {
									"--",
									"--no-deps",
									"-Dclippy::correctness",
									"-Dclippy::complexity",
									"-Wclippy::perf",
									"-Wclippy::pedantic",
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
			})
			rt.inlay_hints.enable()
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = true,
				underline = true,
				severity_sort = false,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
	},
	-- {
	--     "CRAG666/code_runner.nvim",
	--     opts = {
	--         better_term = {
	--             clean = true,
	--         },
	--     },
	--     config = function(_, opts)
	--         local runner = require("code_runner")
	--         runner.setup(opts)
	--     end,
	--     keys = {
	--         { "<f5>", ":RunCode<cr>" },
	--     },
	-- },
	{
		"CRAG666/betterTerm.nvim",
		dependencies = {
			"CRAG666/code_runner.nvim",
		},
		opts = {},
		config = function(_, opts)
			local term = require("betterTerm")
			term.setup(opts)

			vim.keymap.set({ "n", "t" }, "<C-;>", term.open, { desc = "Open terminal" })
			vim.keymap.set("n", "<leader>e", function()
				require("betterTerm").send(
					require("code_runner.commands").get_filetype_command(),
					1,
					{ clean = false, interrupt = true }
				)
			end, { desc = "Excute File" })
		end,
	},
}