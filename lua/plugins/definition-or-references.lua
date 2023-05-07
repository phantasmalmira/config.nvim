return {
  {
    "KostkaBrukowa/definition-or-references.nvim",
    lazy = true,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = function()
      local make_entry = require("telescope.make_entry")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")

      local function filter_entries(results)
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_line = vim.api.nvim_win_get_cursor(0)[1]

        local function should_include_entry(entry)
          -- if entry is on the same line
          if entry.filename == current_file and entry.lnum == current_line then
            return false
          end

          -- if entry is closing tag - just before it there is a closing tag syntax '</'
          if entry.col > 2 and entry.text:sub(entry.col - 2, entry.col - 1) == "</" then
            return false
          end

          return true
        end

        return vim.tbl_filter(should_include_entry, vim.F.if_nil(results, {}))
      end

      local function handle_references_response(result)
        local locations = vim.lsp.util.locations_to_items(result, "utf-8")
        local filtered_entries = filter_entries(locations)
        pickers
          .new({}, {
            prompt_title = "LSP References",
            finder = finders.new_table({
              results = filtered_entries,
              entry_maker = make_entry.gen_from_quickfix(),
            }),
            previewer = require("telescope.config").values.qflist_previewer({}),
            sorter = require("telescope.config").values.generic_sorter({}),
            push_cursor_on_edit = true,
            push_tagstack_on_edit = true,
            initial_mode = "normal",
          })
          :find()
      end
      return {
        on_references_result = handle_references_response,
      }
    end,
  },
}
