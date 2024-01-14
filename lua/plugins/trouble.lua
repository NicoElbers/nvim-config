return {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("trouble").setup()
	end,
	keys = {
		{
			"<leader>tt",
			function()
				require("trouble").toggle()
			end,
		},
		{
			"]d",
			function()
				require("trouble").next({ skip_groups = true, jump = true })
			end,
		},
		{
			"[d",
			function()
				require("trouble").previous({ skip_groups = true, jump = true })
			end,
		},
	},
}
