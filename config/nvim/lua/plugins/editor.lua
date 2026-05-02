-- Editor plugins: comment, surround, autopairs, mini.ai, mini.move, trouble

return {
  -- ─── Comment.nvim ────────────────────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- ─── nvim-surround ───────────────────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts = {},
  },

  -- ─── Autopairs ───────────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },

  -- ─── mini.ai (better text objects) ──────────────────────────────────────
  {
    "echasnovski/mini.ai",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts = { n_lines = 500 },
  },

  -- ─── mini.move (move lines/selections) ──────────────────────────────────
  {
    "echasnovski/mini.move",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts = {
      mappings = {
        left = "<A-Left>",
        right = "<A-Right>",
        down = "<A-Down>",
        up = "<A-Up>",
        line_left = "<A-Left>",
        line_right = "<A-Right>",
        line_down = "<A-Down>",
        line_up = "<A-Up>",
      },
    },
  },

  -- ─── Trouble (diagnostics panel) ─────────────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>xl", "<Cmd>Trouble loclist toggle<CR>", desc = "Location list (Trouble)" },
      { "<leader>xq", "<Cmd>Trouble qflist toggle<CR>", desc = "Quickfix (Trouble)" },
      { "<leader>xL", "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP references (Trouble)" },
    },
  },
}
