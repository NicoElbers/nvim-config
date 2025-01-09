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

    --- @type blink.cmp.Config
    opts = {
        ---@type blink.cmp.KeymapConfig
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

                    if not cmp.is_visible() and vim.fn.mode() == "i" then
                        cmp.show()
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

            ["<C-b>"] = {
                function(cmp)
                    if not cmp.is_visible() then
                        return false
                    end

                    cmp.scroll_documentation_down(5)
                    return true
                end,
            },
            ["<C-h>"] = {
                function(cmp)
                    if not cmp.is_visible() then
                        return false
                    end

                    cmp.scroll_documentation_up(5)
                    return true
                end,
            },
        },

        completion = {
            keyword = {},
            trigger = {},
            accept = {
                auto_brackets = {
                    enabled = false,
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
                update_delay_ms = 0,
                window = {
                    border = utils.border,
                    direction_priority = {
                        menu_north = { "e", "w", "s", "n" },
                        menu_south = { "e", "w", "s", "n" },
                    },
                },
            },
            menu = {
                border = utils.border,
                auto_show = true,
            },
            list = {},
            ghost_text = {},
        },

        appearance = {},

        fuzzy = {
            prebuilt_binaries = {
                download = false,
            },
        },

        signature = {
            enabled = true,
            window = {
                border = utils.border,
            },
        },

        snippets = {},

        sources = {
            -- add lazydev to your completion providers
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            },
        },
    },
}
