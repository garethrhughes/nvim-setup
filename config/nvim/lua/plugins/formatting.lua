-- Formatting: conform.nvim with format-on-save and toggle

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "FormatToggle" },
    keys = {
      {
        "<S-A-f>",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format document",
      },
      {
        "<leader>uf",
        function()
          if vim.b.disable_autoformat then
            vim.b.disable_autoformat = false
            vim.notify("Format on save enabled (buffer)", vim.log.levels.INFO)
          elseif vim.g.disable_autoformat then
            vim.g.disable_autoformat = false
            vim.notify("Format on save enabled (global)", vim.log.levels.INFO)
          else
            vim.g.disable_autoformat = true
            vim.notify("Format on save disabled", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle format on save",
      },
    },
    opts = {
      formatters_by_ft = {
        -- Web
        javascript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        -- Config / data
        json = { "prettierd", "prettier" },
        jsonc = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        -- Markup
        markdown = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        -- Terraform
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        -- Lua
        lua = { "stylua" },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 3000, lsp_fallback = true }
      end,
    },
    config = function(_, opts)
      -- :FormatToggle user command
      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          -- FormatToggle! → buffer-local
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.notify(
            "Buffer format on save: " .. (vim.b.disable_autoformat and "OFF" or "ON"),
            vim.log.levels.INFO
          )
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify(
            "Global format on save: " .. (vim.g.disable_autoformat and "OFF" or "ON"),
            vim.log.levels.INFO
          )
        end
      end, { desc = "Toggle format on save", bang = true })

      require("conform").setup(opts)
    end,
  },
}
