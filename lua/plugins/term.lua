return {
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
