-- LSP: Mason, mason-lspconfig, nvim-lspconfig

return {
  -- Mason: install LSP servers, formatters, linters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- LSP servers
        "vtsls",
        "bash-language-server",
        "terraform-ls",
        "yaml-language-server",
        "json-lsp",
        "marksman",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "lua-language-server",
        -- Formatters
        "prettierd",
        "shfmt",
        "stylua",
        -- Linters
        "eslint_d",
        "shellcheck",
        "tflint",
        "markdownlint-cli2",
        "hadolint",
      },
      ui = { border = "rounded" },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      -- Ensure all packages from ensure_installed are installed
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    opts = {
      automatic_installation = true,
    },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "b0o/schemastore.nvim", lazy = true }, -- JSON/YAML schemas
    },
    config = function()
      local lspconfig = require("lspconfig")

      -- Shared on_attach: keymaps applied once an LSP attaches to a buffer
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gr", vim.lsp.buf.references, "References")
        map("gI", vim.lsp.buf.implementation, "Go to implementation")
        map("gy", vim.lsp.buf.type_definition, "Type definition")
        map("<F12>", vim.lsp.buf.definition, "Go to definition (F12)")
        map("<F2>", vim.lsp.buf.rename, "Rename symbol")
        map("<C-.>", vim.lsp.buf.code_action, "Code action")
        map("<leader>la", vim.lsp.buf.code_action, "Code action")
        map("<leader>lr", vim.lsp.buf.rename, "Rename")
        map("<leader>lh", vim.lsp.buf.hover, "Hover docs")
        map("<leader>ls", vim.lsp.buf.signature_help, "Signature help")
        map("<leader>lR", "<Cmd>Telescope lsp_references<CR>", "References (Telescope)")
        map("<leader>ld", "<Cmd>Telescope lsp_definitions<CR>", "Definition (Telescope)")

        -- Format with <S-A-f>
        vim.keymap.set({ "n", "v" }, "<S-A-f>", function()
          vim.lsp.buf.format({ async = true })
        end, { buffer = bufnr, desc = "LSP: Format document" })
      end

      -- Shared capabilities (extended by nvim-cmp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- ── Server configs ──────────────────────────────────────────────────

      -- TypeScript / JavaScript
      lspconfig.vtsls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "literals" },
              variableTypes = { enabled = true },
              returnTypes = { enabled = true },
            },
          },
        },
      })

      -- Bash
      lspconfig.bashls.setup({ on_attach = on_attach, capabilities = capabilities })

      -- Terraform
      lspconfig.terraformls.setup({ on_attach = on_attach, capabilities = capabilities })

      -- YAML (with schema store)
      lspconfig.yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
            validate = true,
            hover = true,
            completion = true,
          },
        },
      })

      -- JSON (with schema store)
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- Markdown
      lspconfig.marksman.setup({ on_attach = on_attach, capabilities = capabilities })

      -- Docker
      lspconfig.dockerls.setup({ on_attach = on_attach, capabilities = capabilities })
      lspconfig.docker_compose_language_service.setup({ on_attach = on_attach, capabilities = capabilities })

      -- Lua (for editing this config)
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            codeLens = { enable = true },
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- ── Diagnostic display ──────────────────────────────────────────────
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })
    end,
  },
}
