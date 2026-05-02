-- Linting: nvim-lint

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        terraform = { "tflint" },
        markdown = { "markdownlint-cli2" },
        dockerfile = { "hadolint" },
      }

      -- Trigger linting after write and when reading a buffer
      local lint_augroup = vim.api.nvim_create_augroup("NvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint if the linter binary is available
          lint.try_lint()
        end,
      })

      -- Manual trigger
      vim.keymap.set("n", "<leader>ul", function()
        lint.try_lint()
      end, { desc = "Trigger linting" })
    end,
  },
}
