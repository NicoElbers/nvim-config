local api = vim.api
local RunFile = api.nvim_create_augroup("RunFile", { clear = true })

api.nvim_create_autocmd(
    { "FileType" },
    {
        command = "map <buffer> <F5> :w<cr>:exec '!python3' shellescape(@%, 1)<cr>",
        pattern = { "python" },
        group = RunFile,
    }
)
