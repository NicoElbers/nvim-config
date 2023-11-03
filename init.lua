-- initial options
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

opt.wrap = false

opt.nu = true
opt.rnu = true

opt.scrolloff = 15

opt.hlsearch = false
opt.ignorecase = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.clipboard = 'unnamedplus'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = 'nico.lsp' },
}, {})
