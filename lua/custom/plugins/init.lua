-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- {
  --     'theprimeagen/harpoon',
  --     opts = {}
  -- },
  -- -- {
  -- 	'stevearc/oil.nvim',
  -- 	opts = {
  -- 		columns = {
  -- 			"icon",
  -- 			"size",
  -- 		},
  -- 		default_file_explorer = true,
  -- 		restore_win_options = true,
  -- 		delete_to_trash = false,
  -- 		trash_command = "",
  -- 		promp_save_on_select_new_entry = true,
  -- 		use_default_keymaps = true,
  -- 		view_options = {
  -- 			show_hidden = true,
  -- 		},
  -- 	},
  -- 	-- Optional dependencies
  -- 	dependencies = { "nvim-tree/nvim-web-devicons" },
  -- },
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
