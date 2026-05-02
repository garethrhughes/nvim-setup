-- Neo-tree file explorer

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-b>", "<Cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
      { "<leader>fe", "<Cmd>Neotree focus<CR>", desc = "Focus file explorer" },
      { "<leader>fE", "<Cmd>Neotree reveal<CR>", desc = "Reveal current file" },
    },
    opts = {
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = { with_expanders = true },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none", -- don't steal leader
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "disabled",
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { ".git", "node_modules", ".terraform" },
        },
      },
      buffers = { follow_current_file = { enabled = true } },
      git_status = { window = { position = "float" } },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
    end,
  },
}
