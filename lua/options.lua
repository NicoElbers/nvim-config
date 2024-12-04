-- Leader key
vim.g.mapleader = " "

-- Very useful options
-- clipboard
vim.opt.clipboard = "unnamedplus"

-- Line numbers
vim.opt.rnu = true
vim.opt.nu = true
vim.opt.scrolloff = 15

-- Tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Wrap
vim.opt.wrap = false
vim.opt.breakindent = true

-- Undo files
vim.opt.undofile = true

-- Searching
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Update time
vim.opt.updatetime = 100
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Cool colors
vim.opt.cursorline = true
vim.opt.colorcolumn = { 80, 81 }

-- Required for formatting I think, can't be fucked to check
-- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Set whitespace characters
vim.opt.listchars:append({
    multispace = "·",
    lead = "·",
    trail = "·",
    nbsp = "·",
    eol = "↵",
})
vim.opt.list = true

-- local colorschemeName = "catppuccin-mocha"
-- vim.cmd.colorscheme(colorschemeName)

-- -- Change lsp inlay_hint_handler to only show hints on the current line
-- -- https://github.com/neovim/neovim/issues/28261#issuecomment-2130338921
-- local methods = vim.lsp.protocol.Methods
-- local inlay_hint_handler = vim.lsp.handlers[methods["textDocument_inlayHint"]]
-- vim.lsp.handlers[methods["textDocument_inlayHint"]] = function(err, result, ctx, config)
--     local client = vim.lsp.get_client_by_id(ctx.client_id)
--     if client then
--         local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
--         if result == nil then
--             return
--         end
--         result = vim.iter(result)
--             :filter(function(hint)
--                 return hint.position.line + 1 == row
--             end)
--             :totable()
--     end
--     inlay_hint_handler(err, result, ctx, config)
-- end
