-- Make sure lazy exists
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:nocdwendne",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load the things
require("options")
require("keybinds")
require("lazy").setup("plugins")

-- TODO: refactoring and undotree

-- TODO: harpoon maybe
