-- UI plugins: colorscheme, statusline, bufferline, notifications, cmdline

return {
  -- ─── Colorscheme ─────────────────────────────────────────────────────────
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load first
    lazy = false,
    opts = {
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = { enabled = false },
      integrations = {
        bufferline = true,
        cmp = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "underdotted" },
            warnings = { "undercurl" },
            information = { "underdotted" },
          },
        },
        neo_tree = true,
        noice = true,
        notify = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      -- vim.schedule defers until after lazy.nvim has finished updating the rtp,
      -- preventing the "theme not found" warning during :Lazy sync.
      vim.schedule(function()
        vim.cmd.colorscheme("catppuccin")
      end)
    end,
  },

  -- ─── Icons ───────────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- ─── Statusline ──────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
    opts = {
      options = {
        theme = "catppuccin-mocha",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
        },
        lualine_x = {
          {
            function()
              -- Show format-on-save status
              local ok, conform = pcall(require, "conform")
              if ok then
                local enabled = not (vim.g.disable_autoformat or vim.b.disable_autoformat)
                return enabled and " fmt" or " fmt off"
              end
              return ""
            end,
            color = function()
              local enabled = not (vim.g.disable_autoformat or vim.b.disable_autoformat)
              return enabled and { fg = "#a6e3a1" } or { fg = "#f38ba8" }
            end,
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ─── Bufferline ──────────────────────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warning = " ", hint = " ", info = " " }
          local ret = (diag.error and icons.error .. diag.error .. " " or "")
            .. (diag.warning and icons.warning .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "slope",
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },

  -- ─── Notifications ───────────────────────────────────────────────────────
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
      render = "wrapped-compact",
      stages = "fade",
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- ─── Noice (cmdline + messages) ──────────────────────────────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = { enabled = true },
        hover = { enabled = true },
        signature = { enabled = true },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      routes = {
        -- Suppress "written" messages
        { filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
        -- Suppress search count
        { filter = { event = "msg_show", find = "%d+L, %d+B" }, opts = { skip = true } },
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice last message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice history",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice all",
      },
    },
  },

  -- ─── Dashboard (alpha-nvim) ──────────────────────────────────────────────
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- ── Header ──────────────────────────────────────────────────────────
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "                                                     ",
        "         leader = <Space>  ·  Catppuccin Mocha       ",
        "                                                     ",
      }
      dashboard.section.header.opts.hl = "AlphaHeader"

      -- ── Cheatsheet body ─────────────────────────────────────────────────
      local cs = {
        -- section, key, action
        { " SURVIVAL", nil, nil },
        { "  <C-s>", "Save", nil },
        { "  <Esc>", "Normal mode / clear highlight", nil },
        { "  u  /  <C-r>", "Undo / Redo", nil },
        { "  <Space>", "Which-key menu", nil },
        { "", "", nil },
        { " VS CODE PARITY", nil, nil },
        { "  <C-p>", "Quick open file", nil },
        { "  <C-S-p>", "Command palette", nil },
        { "  <C-S-f>", "Find in files", nil },
        { "  <C-b>", "Toggle sidebar", nil },
        { "  <C-`>", "Toggle terminal", nil },
        { "  <C-/>", "Toggle comment", nil },
        { "  <S-A-f>", "Format document", nil },
        { "  <C-.>", "Code action", nil },
        { "  <F2>", "Rename symbol", nil },
        { "  <F12> / gd", "Go to definition", nil },
        { "", "", nil },
        { " LEADER GROUPS", nil, nil },
        { "  <leader>f", "Find  (Telescope)", nil },
        { "  <leader>g", "Git", nil },
        { "  <leader>l", "LSP", nil },
        { "  <leader>b", "Buffer", nil },
        { "  <leader>w", "Window", nil },
        { "  <leader>x", "Diagnostics (Trouble)", nil },
        { "  <leader>t", "Terminal / toggle", nil },
        { "  <leader>u", "UI toggles (format, lint…)", nil },
        { "  <leader>q", "Sessions", nil },
        { "", "", nil },
        { " FIND (Telescope)", nil, nil },
        { "  <leader>ff", "Files", nil },
        { "  <leader>fg", "Live grep", nil },
        { "  <leader>fb", "Buffers", nil },
        { "  <leader>fr", "Recent files", nil },
        { "  <leader>fd", "Diagnostics", nil },
        { "  <leader>ft", "TODOs", nil },
        { "", "", nil },
        { " LSP", nil, nil },
        { "  gr", "References", nil },
        { "  gI", "Implementation", nil },
        { "  gy", "Type definition", nil },
        { "  [d / ]d", "Prev / next diagnostic", nil },
        { "  <leader>e", "Diagnostic float", nil },
        { "", "", nil },
        { " GIT", nil, nil },
        { "  <leader>gg", "Lazygit", nil },
        { "  <leader>gs", "Stage hunk", nil },
        { "  <leader>gp", "Preview hunk", nil },
        { "  <leader>gb", "Blame line", nil },
        { "  <leader>gv", "Diffview", nil },
        { "  ]h / [h", "Next / prev hunk", nil },
        { "", "", nil },
        { " EDITING", nil, nil },
        { '  ysiw"', 'Surround word with "', nil },
        { "  cs\"'", "Change surround \" → '", nil },
        { '  ds"', 'Delete surround "', nil },
        { "  af / if", "Outer / inner function (text obj)", nil },
        { "  aa / ia", "Outer / inner parameter (text obj)", nil },
        { "", "", nil },
        { " COMPLETION", nil, nil },
        { "  <C-Space>", "Trigger completion", nil },
        { "  <C-j/k>", "Next / prev item", nil },
        { "  <CR>", "Confirm", nil },
        { "  <C-e>", "Abort", nil },
      }

      -- Build lines: left-pad, right-align key description pairs
      local lines = {}
      for _, row in ipairs(cs) do
        local key, desc = row[1], row[2]
        if desc == nil then
          -- Section heading
          table.insert(lines, key)
        elseif key == "" then
          table.insert(lines, "")
        else
          table.insert(lines, string.format("%-22s  %s", key, desc))
        end
      end

      dashboard.section.body = {
        type = "text",
        val = lines,
        opts = {
          position = "center",
          hl = "AlphaBody",
        },
      }

      -- ── Buttons ─────────────────────────────────────────────────────────
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", "<Cmd>Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", "<Cmd>Telescope oldfiles<CR>"),
        dashboard.button("g", "  Live grep", "<Cmd>Telescope live_grep<CR>"),
        dashboard.button("s", "  Restore session", "<Cmd>lua require('persistence').load()<CR>"),
        dashboard.button("q", "  Quit", "<Cmd>qa<CR>"),
      }
      dashboard.section.buttons.opts.hl = "AlphaButtons"

      -- ── Footer ──────────────────────────────────────────────────────────
      dashboard.section.footer.val = "  :checkhealth · :Lazy · :Mason"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      -- ── Layout ──────────────────────────────────────────────────────────
      dashboard.config.layout = {
        { type = "padding", val = 1 },
        dashboard.section.header,
        { type = "padding", val = 1 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.body,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.config)

      -- Open alpha when Neovim starts with no file arguments
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("AlphaOnStart", { clear = true }),
        callback = function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
          local is_empty = buf_name == "" and #lines == 1 and lines[1] == ""
          if is_empty then
            require("alpha").start(false)
          end
        end,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = true },
      exclude = {
        filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify" },
      },
    },
  },

  -- ─── Todo comments ───────────────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous TODO",
      },
      { "<leader>ft", "<Cmd>TodoTelescope<CR>", desc = "Find TODOs" },
    },
  },

  -- ─── Which-key ───────────────────────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {},
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
        { "<leader>q", group = "session/quit" },
        { "<leader>s", group = "search/noice" },
        { "<leader>t", group = "terminal/toggle" },
        { "<leader>u", group = "ui/toggles" },
        { "<leader>w", group = "window" },
        { "<leader>x", group = "diagnostics" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}
