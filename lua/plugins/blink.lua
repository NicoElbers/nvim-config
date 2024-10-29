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
            show = "<C-s>",
            hide = "<C-e>",

            show_documentation = "<C-s>",
            hide_documentation = "<C-s>",

            accept = "<C-space>",

            select_next = "<C-n>",
            select_prev = "<C-p>",

            snippet_forward = "<C-n>",
            snippet_backward = "<C-p>",
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
                draw = "reversed",
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
    },
}
