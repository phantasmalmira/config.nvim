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
            n = "lavender",
            i = "green",
            v = "flamingo",
            V = "flamingo",
            ["\22"] = "flamingo",
            c = "peach",
            s = "maroon",
            S = "maroon",
            ["\19"] = "maroon",
            R = "maroon",
            r = "maroon",
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
            hl = { fg = "peach" },
          },
        },
        { -- Trim filename if statusline is too short
          provider = "%<",
        },
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
          hl = { fg = "rosewater" },
        },
      }

      local Ruler = {
        provider = "%7(%l/%3L%):%2c %P ",
      }
      local StatusLine = {
        Mode,
        MacroRecorder,
        BufName,
        { provider = "%=" },
        LspStatus,
        Ruler,
        hl = { bg = "mantle", fg = "text" },
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
          hl = { fg = "peach" },
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
            return { bg = utils.get_highlight("Normal").bg, fg = "text" }
          else
            return "TabLine"
          end
        end,
        TablineFileNameBlock,
        TablineCloseButton,
        { provider = "▐", hl = { fg = "crust", bold = true } },
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
        hl = { bg = "crust" },
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
        local clrs = require("catppuccin.palettes").get_palette()

        return clrs
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
