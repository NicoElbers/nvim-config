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
                    if not cmp.select_next() and cmp.is_in_snippet() then
                        cmp.snippet_forward()
                    end
                    return true
                end,
            },
            ["<C-p>"] = {
                function(cmp)
                    -- If we cannot select prev item and we're in a snippet,
                    -- then go backwards in that snippet
                    if not cmp.select_prev() and cmp.is_in_snippet() then
                        cmp.snippet_backward()
                    end
                    return true
                end,
            },
        },

        highlight = {
            -- sets the fallback highlight groups to nvim-cmp's highlight groups
            -- useful for when your theme doesn't support blink.cmp
            -- will be removed in a future release, assuming themes add support
            use_nvim_cmp_as_default = true,
        },

        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",

        accept = {
            auto_brackets = {
                enabled = true,
            },
        },

        trigger = {
            signature_help = {
                enabled = true,
            },
            completion = {
                show_in_snippet = true,
            },
        },

        windows = {
            autocomplete = {
                border = utils.border,
            },
            documentation = {
                border = utils.border,
                auto_show = true,
                auto_show_delay_ms = 0,
            },
            signature_help = {
                border = utils.border,
            },
        },

        fuzzy = {
            prebuilt_binaries = {
                download = utils.set(true, false),
            },
        },
    },
}
