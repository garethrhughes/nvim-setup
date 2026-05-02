-- Telescope fuzzy finder

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    keys = {
      -- VS Code parity
      { "<C-p>", "<Cmd>Telescope find_files<CR>", desc = "Find files (Ctrl+P)" },
      { "<C-S-p>", "<Cmd>Telescope commands<CR>", desc = "Command palette" },
      { "<C-S-f>", function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Find in files" },

      -- Leader bindings
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Live grep" },
      { "<leader>fb", "<Cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Buffers" },
      { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fr", "<Cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fc", "<Cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
      { "<leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>f.", "<Cmd>Telescope resume<CR>", desc = "Resume last search" },
      { '<leader>f"', "<Cmd>Telescope registers<CR>", desc = "Registers" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
          file_ignore_patterns = { "node_modules", ".git/", ".terraform/", "%.lock" },
          path_display = { "truncate" },
        },
        pickers = {
          find_files = { hidden = true, follow = true },
          buffers = { theme = "dropdown", previewer = false },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "live_grep_args")
    end,
  },
}
