-- LSP: Mason, mason-lspconfig, nvim-lspconfig
-- Uses the nvim 0.11+ vim.lsp.config / vim.lsp.enable API.

return {
  -- Mason: install LSP servers, formatters, linters
  {
    "williamboman/mason.nvim",
    -- Load early on every nvim launch so ensure_installed runs without needing
    -- :Mason to be invoked first. cmd = "Mason" alone would defer installs
    -- until the first explicit :Mason call.
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog", "MasonUninstall", "MasonUninstallAll" },
    event = "VeryLazy",
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

  -- Bridge: mason-lspconfig keeps Mason server names → lspconfig name mapping.
  -- automatic_enable replaces the old .setup() calls when using vim.lsp.enable.
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    opts = {
      automatic_enable = true,
    },
  },

  -- LSP configuration (nvim 0.11+ API)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "b0o/schemastore.nvim", lazy = true }, -- JSON/YAML schemas
    },
    config = function()
      -- ── Capabilities (shared, extended by nvim-cmp) ─────────────────────
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Apply capabilities globally so every server inherits them.
      vim.lsp.config("*", { capabilities = capabilities })

      -- ── Keymaps on attach ────────────────────────────────────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nvim_lsp_attach", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "References")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")
          map("gy", vim.lsp.buf.type_definition, "Type definition")
          map("K", vim.lsp.buf.hover, "Hover docs")
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
        end,
      })

      -- ── Per-server settings ──────────────────────────────────────────────

      -- TypeScript / JavaScript
      vim.lsp.config("vtsls", {
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

      -- YAML (with schema store)
      vim.lsp.config("yamlls", {
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
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- Lua (for editing this config)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            codeLens = { enable = true },
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- Servers with no extra settings are handled automatically by
      -- mason-lspconfig (automatic_enable = true); no explicit enable call
      -- needed for bashls, terraformls, marksman, dockerls,
      -- docker_compose_language_service.

      -- ── Diagnostic display ───────────────────────────────────────────────
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
