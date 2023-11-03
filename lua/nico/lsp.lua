return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      { 'j-hui/fidget.nvim', tag = 'legacy', opt = {} },

      'folke/neodev.nvim',
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },

      inlay_hints = {
        enabled = false,
      },

      capabilities = {},

      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },

      --@type lspconfig.options
      servers = {
        lua_ls = {
          --@type LazyKeysSpec[]
          -- keys = {},

          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },

--        gopls = {},
--        pyright = {},
--        rust_analyzer = {},
--        -- jdtls = {},
--        asm_lsp = {},
--        clangd = {},
      },

      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
--      setup = {},
    },
  },
}
