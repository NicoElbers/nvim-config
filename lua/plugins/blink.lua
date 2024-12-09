-- if true then
--     return {}
-- end

local utils = require("utils")

return {
    "saghen/blink.cmp",
    event = "InsertEnter",

    -- optional: provides snippets for the snippet source
    -- dependencies = { "rafamadriz/friendly-snippets" },

    version = "v0.*",

    opts = {
        keymap = {
            ["<C-s>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide" },

            ["<C-space>"] = { "select_and_accept" },

            ["<C-n>"] = {
                function(cmp)
                    -- If we cannot select next and we're in a snippet,
                    -- then go forward in that snippet
                    if not cmp.select_next() and cmp.snippet_active() then
                        cmp.snippet_forward()
                    end
                    return true
                end,
            },
            ["<C-p>"] = {
                function(cmp)
                    -- If we cannot select prev item and we're in a snippet,
                    -- then go backwards in that snippet
                    if not cmp.select_prev() and cmp.snippet_active() then
                        cmp.snippet_backward()
                    end
                    return true
                end,
            },
        },

        -- Disables keymaps, completions and signature help for these filetypes
        blocked_filetypes = {},
        snippets = {},

        completion = {
            keyword = {},

            trigger = {},

            list = {},

            accept = {
                create_undo_point = true,
                auto_brackets = {
                    enabled = false,
                    semantic_token_resolution = {
                        enabled = true,
                        timeout_ms = 200,
                    },
                },
            },

            menu = {
                enabled = true,
                border = utils.border,
                winblend = 0,

                draw = {
                    treesitter = false,
                },
            },

            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
                update_delay_ms = 50,
                treesitter_highlighting = true,
                window = {
                    border = utils.border,
                    winblend = 0,
                    scrollbar = true,
                },
            },
            -- Displays a preview of the selected item on the current line
            ghost_text = {
                enabled = false,
            },
        },

        -- Experimental signature help support
        signature = {
            enabled = true,
            window = {
                border = utils.border,
                winblend = 0,
                scrollbar = false,
                treesitter_highlighting = true,
            },
        },

        fuzzy = {
            prebuilt_binaries = {
                download = utils.set(true, false), -- Disable for Nixos
            },
        },

        sources = {
            completion = {
                -- Static list of providers to enable, or a function to dynamically enable/disable providers based on the context
                -- enabled_providers = { "lsp", "path", "snippets", "buffer" },
                -- Example dynamically picking providers based on the filetype and treesitter node:
                enabled_providers = function(ctx)
                    local node = vim.treesitter.get_node()
                    if node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
                        return { "buffer" }
                    else
                        return { "lsp", "path", "snippets", "buffer" }
                    end
                end,
            },

            -- Please see https://github.com/Saghen/blink.compat for using `nvim-cmp` sources
            providers = {
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",

                    --- *All* of the providers have the following options available
                    --- NOTE: All of these options may be functions to get dynamic behavior
                    --- See the type definitions for more information.
                    --- Check the enabled_providers config for an example
                    enabled = true, -- Whether or not to enable the provider
                    transform_items = nil, -- Function to transform the items before they're returned
                    should_show_items = true, -- Whether or not to show the items
                    max_items = nil, -- Maximum number of items to display in the menu
                    min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
                    fallback_for = {}, -- If any of these providers return 0 items, it will fallback to this provider
                    score_offset = 0, -- Boost/penalize the score of the items
                    override = nil, -- Override the source's functions
                },
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 3,
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true,
                        get_cwd = function(context)
                            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
                        end,
                        show_hidden_files_by_default = true,
                    },
                },
                snippets = {
                    name = "Snippets",
                    module = "blink.cmp.sources.snippets",
                    score_offset = -3,
                    opts = {
                        friendly_snippets = true,
                        search_paths = { vim.fn.stdpath("config") .. "/snippets" },
                        global_snippets = { "all" },
                        extended_filetypes = {},
                        ignored_filetypes = {},
                        get_filetype = function(context)
                            return vim.bo.filetype
                        end,
                    },

                    --- Example usage for disabling the snippet provider after pressing trigger characters (i.e. ".")
                    -- enabled = function(ctx)
                    --   return ctx ~= nil and ctx.trigger.kind == vim.lsp.protocol.CompletionTriggerKind.TriggerCharacter
                    -- end,
                },
                buffer = {
                    name = "Buffer",
                    module = "blink.cmp.sources.buffer",
                    fallback_for = { "lsp" },
                    opts = {
                        -- default to all visible buffers
                        get_bufnrs = function()
                            return vim.iter(vim.api.nvim_list_wins())
                                :map(function(win)
                                    return vim.api.nvim_win_get_buf(win)
                                end)
                                :filter(function(buf)
                                    return vim.bo[buf].buftype ~= "nofile"
                                end)
                                :totable()
                        end,
                    },
                },
            },
        },

        appearance = {
            highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
            -- Sets the fallback highlight groups to nvim-cmp's highlight groups
            -- Useful for when your theme doesn't support blink.cmp
            -- Will be removed in a future release
            use_nvim_cmp_as_default = true,
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
            kind_icons = {
                Text = "󰉿",
                Method = "󰊕",
                Function = "󰊕",
                Constructor = "󰒓",

                Field = "󰜢",
                Variable = "󰆦",
                Property = "󰖷",

                Class = "󱡠",
                Interface = "󱡠",
                Struct = "󱡠",
                Module = "󰅩",

                Unit = "󰪚",
                Value = "󰦨",
                Enum = "󰦨",
                EnumMember = "󰦨",

                Keyword = "󰻾",
                Constant = "󰏿",

                Snippet = "󱄽",
                Color = "󰏘",
                File = "󰈔",
                Reference = "󰬲",
                Folder = "󰉋",
                Event = "󱐋",
                Operator = "󰪚",
                TypeParameter = "󰬛",
            },
        },
    },
}
