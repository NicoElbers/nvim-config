return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "theHamsta/nvim-dap-virtual-text",
        "williamboman/mason.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function(_, opts)
        local dap = require("dap")
        local dap_virt = require("nvim-dap-virtual-text")
        local mason_registry = require("mason-registry")

        local binary_path = nil
        -- Keymap functions
        local get_binary_path = function()
            local cwd = vim.fn.getcwd()
            local filetype = vim.bo.filetype

            local starting_dir = cwd
            if filetype == "rust" then
                starting_dir = starting_dir .. "/target/debug/"
            end
            binary_path = vim.fn.input("Exe name: ", starting_dir, "file")
            return binary_path
        end

        dap.adapters.lldb = {
            type = "executable",
            command = "/usr/bin/lldb-vscode",
            name = "lldb",
        }

        -- local pickers = require("telescope.pickers")
        -- local finders = require("telescope.finders")
        -- local conf = require("telescope.config").values
        -- local actions = require("telescope.actions")
        -- local action_state = require("telescope.actions.state")
        dap.configurations.rust = {
            {
                name = "Launch",
                type = "lldb",
                request = "launch",
                program = function()
                    -- return coroutine.create(function(coro)
                    --     local opts = {}
                    --     pickers
                    --         .new(opts, {
                    --             prompt_title = "Path to executable",
                    --             finder = finders.new_oneshot_job(
                    --                 { "fd", "--hidden", "--no-ignore", "--type", "x" },
                    --                 {}
                    --             ),
                    --             sorter = conf.generic_sorter(opts),
                    --             attach_mappings = function(buffer_number)
                    --                 actions.select_default:replace(function()
                    --                     actions.close(buffer_number)
                    --                     coroutine.resume(coro, action_state.get_selected_entry()[1])
                    --                 end)
                    --                 return true
                    --             end,
                    --         })
                    --         :find()
                    -- end)
                    vim.fn.system("cargo build")
                    -- return vim.fn.input("Exe name: ", vim.fn.getcwd() .. "/target/debug", "file")
                    if binary_path ~= nil then
                        return binary_path
                    else
                        return get_binary_path()
                    end
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                initCommand = function()
                    local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

                    local script_import = 'command script import "'
                        .. rustc_sysroot
                        .. '/lib/rustlib/etc/lldb_lookup.py"'
                    local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

                    local commands = {}
                    local file = io.open(commands_file, "r")
                    if file then
                        for line in file:lines() do
                            table.insert(commands, line)
                        end
                        file:close()
                    end

                    table.insert(commands, 1, script_import)

                    return commands
                end,
                args = {},
            },
        }

        dap_virt.setup({})
        -- Keymaps
        vim.keymap.set("n", "<F5>", dap.continue)
        vim.keymap.set("n", "<F8>", dap.step_over)
        vim.keymap.set("n", "<F9>", dap.step_into)
        vim.keymap.set("n", "<F10>", dap.step_out)
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
    end,
}
