return {
  {
    "rebelot/heirline.nvim",
    opts = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local Mode = {
        {
          hl = function(self)
            return vim.tbl_extend("force", utils.get_highlight(self.colors[self.mode_short]), { bold = true })
          end,
          provider = function(self)
            return "  " .. self.mode_names[self.mode] .. " "
          end,
        },
        {
          provider = " ",
          hl = function(self)
            return vim.tbl_extend(
              "force",
              utils.get_highlight(self.colors[self.mode_short]),
              { reverse = true, fg = utils.get_highlight("Normal").bg }
            )
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

      local WorkDir = {
        init = function(self)
          self.icon = " "
          local cwd = vim.fn.getcwd(0)
          self.cwd = vim.fn.fnamemodify(cwd, ":~")
        end,
        {
          hl = function(self)
            local fg = utils.get_highlight(self.colors[self.mode_short]).bg
            if conditions.is_git_repo() then
              return { fg = fg, bg = utils.get_highlight("HeirlineStatusGit").bg }
            elseif conditions.lsp_attached() then
              return { fg = fg, bg = utils.get_highlight("HeirlineStatusLsp").bg }
            else
              return { fg = fg, bg = utils.get_highlight("Normal").bg }
            end
          end,
          provider = "",
        },
        {
          -- evaluates to the shortened path
          provider = function(self)
            local folder_name = vim.fn.fnamemodify(self.cwd, ":t")
            return " " .. self.icon .. folder_name .. " "
          end,
        },
        {
          provider = "%<",
        },
        hl = function(self)
          return vim.tbl_extend("force", utils.get_highlight(self.colors[self.mode_short]), { bold = true })
        end,
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

      local LspProgress = {
        init = function(self)
          self.progress = require("lsp-status").status_progress()
        end,
        {
          condition = function(self)
            return self.progress:len() > 0
          end,
          {
            hl = { fg = "orange", bg = "green" },
            provider = "",
          },
          {
            provider = function(self)
              return self.progress and self.progress .. " "
            end,
            hl = { bg = "orange", fg = "bright_bg", bold = true },
          },
        },
      }

      local LspStatus = {
        condition = function()
          return conditions.lsp_attached()
        end,
        {
          hl = function()
            return { fg = utils.get_highlight("HeirlineStatusLsp").bg }
          end,
          provider = "",
        },
        {
          hl = "HeirlineStatusLsp",
          { provider = " " },
          {
            hl = { bold = true },
            provider = " LSP ",
          },
          on_click = {
            callback = function()
              vim.defer_fn(function()
                require("lspconfig.ui.lspinfo")()
              end, 100)
            end,
            name = "heirline_lspinfo",
          },
        },
      }

      local Diagnostics = {

        condition = conditions.has_diagnostics,

        static = {
          error_icon = " ",
          warn_icon = " ",
          info_icon = " ",
          hint_icon = " ",
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

      local GitStats = {
        condition = conditions.is_git_repo,
        -- You could handle delimiters, icons and counts similar to Diagnostics
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
        end,
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and (" " .. count .. " ")
          end,
          hl = { fg = "git_add" },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and (" " .. count .. " ")
          end,
          hl = { fg = "git_del" },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and (" " .. count .. " ")
          end,
          hl = { fg = "git_change" },
        },
      }

      local Git = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,
        {
          hl = function()
            local bg = conditions.lsp_attached() and utils.get_highlight("HeirlineStatusLsp").bg
              or utils.get_highlight("Normal").bg
            return { fg = utils.get_highlight("HeirlineStatusGit").bg, bg = bg }
          end,
          provider = "",
        },

        {
          hl = "HeirlineStatusGit",
          { provider = "  " },
          { -- git branch name
            provider = function(self)
              return self.status_dict.head .. " "
            end,
            hl = { bold = true },
          },
        },
      }

      local Ruler = {
        provider = "%P %7(%l/%3L%):%-2c ",
        hl = { fg = "gray" },
      }
      local StatusLine = {
        static = {
          mode_names = {
            n = "NORMAL",
            no = "NORMAL-O",
            nov = "NORMAL-O-CHAR",
            noV = "NORMAL-O-LINE",
            ["no\22"] = "NORMAL-O-BLOCK",
            niI = "NORMAL-I",
            niR = "NORMAL-R",
            niV = "NORMAL-V",
            nt = "NORMAL-T",
            v = "VISUAL",
            vs = "VISUAL-S",
            V = "LINE",
            Vs = "LINE-S",
            ["\22"] = "BLOCK",
            ["\22s"] = "BLOCK-S",
            s = "SELECT",
            S = "SELECT-L",
            ["\19"] = "SELECT-B",
            i = "INSERT",
            ic = "INSERT-C",
            ix = "INSERT-X",
            R = "REPLACE",
            Rc = "REPLACE-C",
            Rx = "REPLACE-X",
            Rv = "REPLACE-V",
            Rvc = "REPLACE-VC",
            Rvx = "REPLACE-VX",
            c = "COMMAND",
            cv = "EX-COMMAND",
            r = "ENTER?",
            rm = "MORE",
            ["r?"] = "CONFIRM?",
            ["!"] = "SHELL",
            t = "TERMINAL",
          },
          colors = {
            n = "HeirlineStatusNormal",
            i = "HeirlineStatusInsert",
            v = "HeirlineStatusVisual",
            V = "HeirlineStatusVisual",
            ["\22"] = "HeirlineStatusVisual",
            c = "HeirlineStatusCommand",
            s = "HeirlineStatusSelect",
            S = "HeirlineStatusSelect",
            ["\19"] = "HeirlineStatusSelect",
            R = "HeirlineStatusReplace",
            r = "HeirlinerStatusReplace",
            ["!"] = "HeirlineStatusShell",
            t = "HeirlineStatusTerminal",
          },
        },
        init = function(self)
          self.mode = vim.fn.mode(1)
          self.mode_short = self.mode:sub(1, 1)
        end,
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
        },
        {
          Mode,
          Ruler,
          MacroRecorder,
        },
        { provider = "%=" },
        {
          BufName,
          Diagnostics,
        },
        { provider = "%=" },
        {
          GitStats,
          LspStatus,
          Git,
          WorkDir,
        },
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
          status_normal = utils.get_highlight("HeirlineStatusNormal"),
          status_insert = utils.get_highlight("HeirlineStatusInsert"),
          status_visual = utils.get_highlight("HeirlineStatusVisual"),
          status_replace = utils.get_highlight("HeirlineStatusReplace"),
          status_command = utils.get_highlight("HeirlineStatusCommand"),
          status_select = utils.get_highlight("HeirlineStatusSelect"),
          status_shell = utils.get_highlight("HeirlineStatusShell"),
          status_terminal = utils.get_highlight("HeirlineStatusTerminal"),
          status_git = utils.get_highlight("HeirlineStatusGit"),
          status_lsp = utils.get_highlight("HeirlineStatusLsp"),
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
