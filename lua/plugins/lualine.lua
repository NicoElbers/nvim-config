return {
	"nvim-lualine/lualine.nvim",
	event = { "BufRead", "BufWrite", "BufNewFile" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "dracula",
		},
	},
}
