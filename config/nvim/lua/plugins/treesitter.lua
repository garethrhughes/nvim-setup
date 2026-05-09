-- Treesitter: syntax, indentation, textobjects

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Pin to the legacy master branch: the new `main` branch is a partial
    -- rewrite whose setup() ignores ensure_installed/highlight/indent/textobjects.
    branch = "master",
    build = ":TSUpdate",
    -- Load at startup: treesitter must be configured before buffers open.
    -- Lazy-loading on BufReadPost causes config-not-ready errors during install.
    lazy = false,
    -- Tell lazy.nvim which module to call setup() on (master branch's setup
    -- lives in nvim-treesitter.configs, not the top-level module).
    main = "nvim-treesitter.configs",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
    },
    opts = {
      ensure_installed = {
        "bash",
        -- "comment" parser removed in treesitter >=0.9; highlights handled natively
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
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
        },
      },
    },
  },
}
