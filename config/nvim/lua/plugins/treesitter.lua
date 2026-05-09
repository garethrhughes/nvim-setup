-- Treesitter: syntax, indentation, textobjects
--
-- nvim-treesitter main branch is the rewrite required for nvim 0.10+.
-- Its setup() API only accepts install_dir; everything else is handled via
-- shipped ftplugins (highlight, indent) and explicit install() calls (parsers).
-- The legacy master branch is incompatible with nvim 0.10+ Node API changes.

return {
  -- ─── Core parser + runtime ───────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      require("nvim-treesitter").setup()
      -- Install missing parsers asynchronously; already-installed ones are
      -- skipped. install() is async so this does not block startup.
      require("nvim-treesitter").install({
        "bash",
        "css",
        "dockerfile",
        "hcl",
        "html",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "regex",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      })
    end,
  },

  -- ─── Textobjects ─────────────────────────────────────────────────────────
  -- In the main-branch API keymaps are registered manually; the setup() call
  -- only holds behavioural options (lookahead, set_jumps, etc.).
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      -- Selection (operator-pending + visual)
      local sel = require("nvim-treesitter-textobjects.select")
      local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      }
      for key, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          sel.select_textobject(query, "textobjects")
        end, { desc = "TS: " .. query })
      end

      -- Movement (next / previous)
      local mov = require("nvim-treesitter-textobjects.move")
      local move_maps = {
        ["]f"] = { "goto_next_start", "@function.outer" },
        ["]c"] = { "goto_next_start", "@class.outer" },
        ["[f"] = { "goto_previous_start", "@function.outer" },
        ["[c"] = { "goto_previous_start", "@class.outer" },
      }
      for key, spec in pairs(move_maps) do
        local fn, query = spec[1], spec[2]
        vim.keymap.set("n", key, function()
          mov[fn](query, "textobjects")
        end, { desc = "TS: " .. fn:gsub("_", " ") .. " " .. query })
      end
    end,
  },
}
