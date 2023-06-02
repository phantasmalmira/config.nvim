return {
  {
    "rebelot/heirline.nvim",
    opts = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local Mode = {
        static = {
          mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
          },
          colors = {
            n = "blue",
            i = "green",
            v = "purple",
            V = "purple",
            ["\22"] = "purple",
            c = "orange",
            s = "red",
            S = "red",
            ["\19"] = "red",
            R = "red",
            r = "red",
            ["!"] = "green",
            t = "green",
          },
        },
        init = function(self)
          self.mode = vim.fn.mode(1)
        end,
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
        },
        {
          provider = " ",
          hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { bg = self.colors[mode] }
          end,
        },
        {
          hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = self.colors[mode], bold = true, reverse = true }
          end,
          provider = function(self)
            return " " .. self.mode_names[self.mode]
          end,
        },
        {
          provider = " ",
          hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { bg = self.colors[mode] }
          end,
        },
        {
          provider = " ",
          hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = self.colors[mode] }
          end,
        },
      }

      local MacroRecorder = {
        provider = function()
          return " " .. vim.fn.reg_recording() .. " "
        end,
        condition = function()
          return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
        end,
        hl = { fg = "red" },
        update = {
          "RecordingEnter",
          "RecordingLeave",
        },
      }

      local BufIcon = {
        init = function(self)
          local extension = vim.fn.fnamemodify(self.filename, ":e")
          self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(self.filename, extension, { default = true })
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end,
        provider = function(self)
          return self.icon and self.icon .. " "
        end,
      }

      local BufName = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
        BufIcon,
        { -- File name
          provider = function(self)
            local filename = vim.fn.fnamemodify(self.filename, ":.")
            if filename == "" then
              return "[No Name]"
            end
            if not conditions.width_percent_below(#filename, 0.25) then
              filename = vim.fn.pathshorten(filename)
            end
            return filename
          end,
        },
        { provider = " " },
        { -- File flags
          {
            condition = function()
              return vim.bo.readonly or not vim.bo.modifiable
            end,
            provider = " ",
            hl = { fg = "yellow" },
          },
          {
            condition = function()
              return vim.bo.modified
            end,
            provider = " ",
            hl = { fg = "orange" },
          },
        },
        { -- Trim filename if statusline is too short
          provider = "%<",
        },
      }

      local Navic = {
        condition = function()
          return conditions.lsp_attached() and package.loaded["nvim-navic"] and require("nvim-navic").is_available()
        end,
        static = {
          -- create a type highlight map
          type_hl = {
            File = "Directory",
            Module = "@include",
            Namespace = "@namespace",
            Package = "@include",
            Class = "@structure",
            Method = "@method",
            Property = "@property",
            Field = "@field",
            Constructor = "@constructor",
            Enum = "@field",
            Interface = "@type",
            Function = "@function",
            Variable = "@variable",
            Constant = "@constant",
            String = "@string",
            Number = "@number",
            Boolean = "@boolean",
            Array = "@field",
            Object = "@type",
            Key = "@keyword",
            Null = "@comment",
            EnumMember = "@field",
            Struct = "@structure",
            Event = "@keyword",
            Operator = "@operator",
            TypeParameter = "@type",
          },
          -- bit operation dark magic, see below...
          enc = function(line, col, winnr)
            return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
          end,
          -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
          dec = function(c)
            local line = bit.rshift(c, 16)
            local col = bit.band(bit.rshift(c, 6), 1023)
            local winnr = bit.band(c, 63)
            return line, col, winnr
          end,
        },
        init = function(self)
          local data = require("nvim-navic").get_data() or {}
          local children = {}
          -- create a child for each level
          for i, d in ipairs(data) do
            -- encode line and column numbers into a single integer
            local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
            local child = {
              {
                provider = d.icon,
                hl = self.type_hl[d.type],
              },
              {
                -- escape `%`s (elixir) and buggy default separators
                provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
                -- highlight icon only or location name as well
                -- hl = self.type_hl[d.type],

                on_click = {
                  -- pass the encoded position through minwid
                  minwid = pos,
                  callback = function(_, minwid)
                    -- decode
                    local line, col, winnr = self.dec(minwid)
                    vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
                  end,
                  name = "heirline_navic",
                },
                hl = self.type_hl[d.type],
              },
            }
            -- add a separator only if needed
            if #data > 1 and i < #data then
              table.insert(child, {
                provider = " > ",
              })
            end
            table.insert(children, child)
          end
          -- instantiate the new child, overwriting the previous one
          self.child = self:new(children, 1)
        end,
        -- evaluate the children containing navic components
        provider = function(self)
          return self.child:eval()
        end,
        hl = { fg = "gray" },
        update = "CursorMoved",
      }

      local LspStatus = {
        condition = function()
          return conditions.lsp_attached()
        end,
        {
          hl = { fg = "green" },
          provider = " LSP ",
          on_click = {
            callback = function()
              vim.defer_fn(function()
                require("lspconfig.ui.lspinfo")()
              end, 100)
            end,
            name = "heirline_lspinfo",
          },
        },
        {
          provider = function(self)
            local progress = require("lsp-status").status_progress()
            return progress and progress .. " "
          end,
          hl = { fg = "orange" },
        },
      }

      local Diagnostics = {

        condition = conditions.has_diagnostics,

        static = {
          error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
          warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
          info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
          hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
        },

        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        update = { "DiagnosticChanged", "BufEnter" },

        { provider = " " },
        {
          provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
          end,
          hl = { fg = "diag_error" },
        },
        {
          provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
          end,
          hl = { fg = "diag_warn" },
        },
        {
          provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
          end,
          hl = { fg = "diag_info" },
        },
        {
          provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
          end,
          hl = { fg = "diag_hint" },
        },
        { provider = " " },
      }

      local Git = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,

        hl = { fg = "orange" },

        { -- git branch name
          provider = function(self)
            return " " .. self.status_dict.head
          end,
          hl = { bold = true },
        },
        -- You could handle delimiters, icons and counts similar to Diagnostics
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = "(",
        },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
          end,
          hl = { fg = "git_add" },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
          end,
          hl = { fg = "git_del" },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
          end,
          hl = { fg = "git_change" },
        },
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = ")",
        },
      }

      local Ruler = {
        provider = "%7(%l/%3L%):%2c %P ",
      }
      local StatusLine = {
        Mode,
        MacroRecorder,
        BufName,
        Navic,
        { provider = "%=" },
        LspStatus,
        Diagnostics,
        Git,
        Ruler,
        hl = "Normal",
        condition = function()
          return not conditions.buffer_matches({
            filetype = {
              "neo-tree",
              "alpha",
            },
          })
        end,
      }

      local TablineFileName = {
        provider = function(self)
          -- self.filename will be defined later, just keep looking at the example!
          local filename = self.filename
          filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
          return filename .. " "
        end,
        hl = function(self)
          return { bold = self.is_active or self.is_visible, italic = self.is_active or self.is_visible }
        end,
      }

      local TablineFileFlags = {
        {
          condition = function(self)
            return vim.api.nvim_buf_get_option(self.bufnr, "modified")
          end,
          provider = " ",
          hl = { fg = "orange" },
        },
        {
          condition = function(self)
            return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
              or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
          end,
          provider = function(self)
            if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
              return " "
            else
              return " "
            end
          end,
          hl = { fg = "orange" },
        },
      }

      -- Here the filename block finally comes together
      local TablineFileNameBlock = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        end,
        on_click = {
          callback = function(_, minwid, _, button)
            if button == "m" then -- close on mouse middle click
              vim.schedule(function()
                vim.api.nvim_buf_delete(minwid, { force = false })
              end)
            else
              vim.api.nvim_win_set_buf(0, minwid)
            end
          end,
          minwid = function(self)
            return self.bufnr
          end,
          name = "heirline_tabline_buffer_callback",
        },
        { provider = "  " },
        BufIcon,
        TablineFileName,
        TablineFileFlags,
      }

      local TablineCloseButton = {
        condition = function(self)
          return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
        end,
        { provider = " " },
        {
          provider = " ",
          on_click = {
            callback = function(_, minwid)
              vim.schedule(function()
                vim.api.nvim_buf_delete(minwid, { force = false })
                vim.cmd.redrawtabline()
              end)
            end,
            minwid = function(self)
              return self.bufnr
            end,
            name = "heirline_tabline_close_buffer_callback",
          },
        },
      }

      -- The final touch!
      local TablineBufferBlock = {
        hl = function(self)
          if self.is_active then
            return "Normal"
          else
            return "TabLine"
          end
        end,
        TablineFileNameBlock,
        TablineCloseButton,
        { provider = "▐", hl = { fg = "gray", bold = true } },
      }
      -- this is the default function used to retrieve buffers
      local get_bufs = function()
        return vim.tbl_filter(function(bufnr)
          return vim.api.nvim_buf_get_option(bufnr, "buflisted")
        end, vim.api.nvim_list_bufs())
      end

      -- initialize the buflist cache
      local buflist_cache = {}

      -- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
      vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            local buffers = get_bufs()
            for i, v in ipairs(buffers) do
              buflist_cache[i] = v
            end
            for i = #buffers + 1, #buflist_cache do
              buflist_cache[i] = nil
            end

            -- check how many buffers we have and set showtabline accordingly
            if #buflist_cache > 1 then
              vim.o.showtabline = 2 -- always
            else
              vim.o.showtabline = 1 -- only when #tabpages > 1
            end
          end)
        end,
      })

      -- and here we go
      local BufferLine = utils.make_buflist(
        TablineBufferBlock,
        { provider = "", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
        { provider = "", hl = { fg = "gray" } }, -- right trunctation, also optional (defaults to ...... yep, ">")
        -- by the way, open a lot of buffers and try clicking them ;)
        function()
          return buflist_cache
        end,
        false
      )

      local TabLineOffset = {
        condition = function(self)
          local win = vim.api.nvim_tabpage_list_wins(0)[1]
          local bufnr = vim.api.nvim_win_get_buf(win)
          self.winid = win

          if vim.bo[bufnr].filetype == "neo-tree" then
            self.title = "Files"
            return true
            -- elseif vim.bo[bufnr].filetype == "TagBar" then
            --     ...
          end
        end,

        provider = function(self)
          local title = self.title
          local width = vim.api.nvim_win_get_width(self.winid)
          local pad = math.ceil((width - #title) / 2)
          return string.rep(" ", pad) .. title .. string.rep(" ", pad)
        end,

        hl = "NeoTreeNormal",
      }

      local TabLine = {
        TabLineOffset,
        BufferLine,
        { provider = "%=" },
        hl = "Normal",
      }
      local WinBar = {}
      local StatusColumn = {}

      return {
        statusline = StatusLine,
        tabline = TabLine,
      }
    end,
    config = function(_, opts)
      require("heirline").setup(opts)

      local function load_colors()
        local utils = require("heirline.utils")
        local colors = {
          bright_bg = utils.get_highlight("Folded").bg,
          bright_fg = utils.get_highlight("Folded").fg,
          red = utils.get_highlight("DiagnosticError").fg,
          dark_red = utils.get_highlight("DiffDelete").bg,
          green = utils.get_highlight("String").fg,
          blue = utils.get_highlight("Function").fg,
          gray = utils.get_highlight("NonText").fg,
          orange = utils.get_highlight("Constant").fg,
          purple = utils.get_highlight("Statement").fg,
          yellow = utils.get_highlight("WarningMsg").fg,
          cyan = utils.get_highlight("Special").fg,
          diag_warn = utils.get_highlight("DiagnosticWarn").fg,
          diag_error = utils.get_highlight("DiagnosticError").fg,
          diag_hint = utils.get_highlight("DiagnosticHint").fg,
          diag_info = utils.get_highlight("DiagnosticInfo").fg,
          git_del = utils.get_highlight("DiagnosticError").fg,
          git_add = utils.get_highlight("String").fg,
          git_change = utils.get_highlight("DiagnosticWarn").fg,
        }
        return colors
      end
      require("heirline").load_colors(load_colors())

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("Heirline", { clear = true }),
        callback = function()
          require("heirline.utils").on_colorscheme(load_colors)
        end,
      })
    end,
  },
}
