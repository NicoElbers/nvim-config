-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    opts = {
      filesystem = {
        follow_current_file = true,
        use_libuv_file_watcher = true,
        close_if_last_window = true,
      },
      window = {
        width = 35,
        mappings = {
          ["Z"] = "expand_all_nodes",
          ["<space>"] = false,
          ["<cr>"] = "open",

        }
      }
    },
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  }
}
