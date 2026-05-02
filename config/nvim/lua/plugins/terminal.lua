-- Terminal: toggleterm

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-`>", "<Cmd>ToggleTerm<CR>", mode = { "n", "i", "t" }, desc = "Toggle terminal" },
      { "<leader>tt", "<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal (horizontal)" },
      { "<leader>tv", "<Cmd>ToggleTerm direction=vertical size=60<CR>", desc = "Terminal (vertical)" },
      { "<leader>tf", "<Cmd>ToggleTerm direction=float<CR>", desc = "Terminal (float)" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping = nil, -- managed via keys above
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 3,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- <Esc> to exit terminal mode without closing
      vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    end,
  },
}
