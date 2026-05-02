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
        close_command = function(bufnr)
          require("core.buffer").smart_bdelete(bufnr, false)
        end,
        right_mouse_command = function(bufnr)
          require("core.buffer").smart_bdelete(bufnr, false)
        end,
        custom_filter = function(buf_number)
          -- Hide empty unnamed buffers from the bufferline tab strip
          local name = vim.api.nvim_buf_get_name(buf_number)
          if name == "" and vim.bo[buf_number].filetype == "" then
            return false
          end
          return true
        end,
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
    event = "VimEnter",
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

      -- Build lines dynamically at draw time so they fit the available width.
      -- Available width = total columns minus neo-tree sidebar (35) minus separator (1).
      local function build_body_lines()
        local sidebar_w = 36 -- neo-tree width (35) + border
        local avail = math.max(40, vim.o.columns - sidebar_w)
        local key_w = 22
        local sep = "  "
        local desc_w = avail - key_w - #sep
        local out = {}
        for _, row in ipairs(cs) do
          local key, desc = row[1], row[2]
          if desc == nil then
            table.insert(out, key)
          elseif key == "" then
            table.insert(out, "")
          else
            -- Truncate description if it overflows
            local d = desc
            if #d > desc_w and desc_w > 3 then
              d = d:sub(1, desc_w - 1) .. "…"
            end
            table.insert(out, string.format("%-" .. key_w .. "s%s%s", key, sep, d))
          end
        end
        return out
      end

      dashboard.section.body = {
        type = "text",
        val = build_body_lines,
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

      dashboard.config.opts = vim.tbl_extend("force", dashboard.config.opts or {}, {
        -- autostart = true: alpha handles the no-arg case itself, calling
        -- start(true) which reuses buffer #1 (so no [No Name] in bufferline).
        autostart = true,
        redraw_on_resize = true,
      })

      alpha.setup(dashboard.config)

      -- ── Directory-arg startup ───────────────────────────────────────────
      -- For `nvim .` (or any single dir arg): cd into it, drop the directory
      -- buffer nvim created, draw alpha into the current window, then open
      -- neo-tree. We force-bypass alpha's should_skip_alpha guard by calling
      -- start(false) after we've cleared the dir buffer's contents.
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("AlphaDirArg", { clear = true }),
        nested = true,
        once = true,
        callback = function()
          if vim.fn.argc() ~= 1 then
            return
          end
          local arg = vim.fn.argv(0)
          if vim.fn.isdirectory(arg) ~= 1 then
            return
          end
          vim.cmd("cd " .. vim.fn.fnameescape(arg))
          -- Suppress AlphaOnLastClose while we rearrange buffers; the empty
          -- buffer left after wiping the dir buffer would otherwise trigger it.
          vim.g._alpha_dir_startup = true
          -- Wipe the directory buffer that argv created
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) then
              local name = vim.api.nvim_buf_get_name(buf)
              if name ~= "" and vim.fn.isdirectory(name) == 1 then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
              end
            end
          end
          -- Open neo-tree so alpha renders into the correct (narrower) width.
          vim.cmd("Neotree show")
          -- Defer alpha.start past the current tick. neo-tree schedules an
          -- async set_current_win(original_win) callback; if we call
          -- alpha.start synchronously that window gets destroyed before the
          -- callback fires (invalid window id). vim.defer_fn(fn, 0) fires
          -- after all pending vim.schedule callbacks, so neo-tree's callback
          -- completes first and the window is safe to use.
          vim.defer_fn(function()
            -- Keep the startup guard active during set_current_win — that call
            -- fires BufEnter which would otherwise trigger AlphaOnLastClose
            -- prematurely, causing a double alpha.start and a closed window.
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_is_valid(win) and vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "neo-tree" then
                vim.api.nvim_set_current_win(win)
                break
              end
            end
            -- start(false) bypasses should_skip_alpha (argc > 0 would skip).
            alpha.start(false)
            -- Clear only after alpha.start so no intermediate BufEnter can
            -- sneak through the guard window.
            vim.g._alpha_dir_startup = nil
          end, 0)
        end,
      })

      -- ── Safety net: return to alpha on entering empty unnamed buffer ────
      -- When the last real buffer is closed nvim may land on a fresh empty
      -- [No Name] buffer; swap it for alpha so the dashboard reappears.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("AlphaOnLastClose", { clear = true }),
        callback = function()
          -- Suppress during dir-arg startup: the empty buffer left after
          -- wiping the directory buffer is not a "last buffer closed" event.
          if vim.g._alpha_dir_startup then
            return
          end
          -- Ignore floating windows (telescope, lazy, etc.) — their transient
          -- empty prompt buffers would otherwise be mistaken for "no buffers".
          if vim.api.nvim_win_get_config(0).relative ~= "" then
            return
          end
          local buf = vim.api.nvim_get_current_buf()
          -- Skip scratch/plugin buffers (nofile, prompt, terminal, etc.)
          if vim.bo[buf].buftype ~= "" then
            return
          end
          if vim.api.nvim_buf_get_name(buf) ~= "" then
            return
          end
          local lines = vim.api.nvim_buf_get_lines(buf, 0, 2, false)
          if #lines > 1 or (#lines == 1 and lines[1] ~= "") then
            return
          end
          if vim.bo[buf].filetype == "alpha" then
            return
          end
          -- Only fire if no other real buffers (excluding empty unnamed ones,
          -- alpha, and neo-tree) exist
          for _, b in ipairs(vim.api.nvim_list_bufs()) do
            if b ~= buf and vim.bo[b].buflisted then
              local ft = vim.bo[b].filetype
              if ft ~= "alpha" and ft ~= "neo-tree" then
                local bname = vim.api.nvim_buf_get_name(b)
                if bname ~= "" then
                  return
                end
                local blines = vim.api.nvim_buf_get_lines(b, 0, 2, false)
                if #blines > 1 or (#blines == 1 and blines[1] ~= "") then
                  return
                end
              end
            end
          end
          alpha.start(false)
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
