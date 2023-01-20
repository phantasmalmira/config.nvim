return function()
  local copilot = require('copilot')
  local copilot_suggestion = require('copilot.suggestion')

  -- copilot
  copilot.setup({
    suggestion = {
      auto_trigger = true
    }
  })
  vim.cmd('Copilot auth')

  local function acceptSuggestion()
    if copilot_suggestion.is_visible() then
      vim.schedule(copilot_suggestion.accept)
    else
      return '<Tab>'
    end
  end

  local function cancelSuggestion()
    if copilot_suggestion.is_visible() then
      vim.schedule(copilot_suggestion.dismiss)
    else
      return '<Esc>'
    end
  end

  vim.keymap.set('i', '<Tab>', acceptSuggestion, { silent = true, expr = true })
  vim.keymap.set('i', '<Esc>', cancelSuggestion, { silent = true, expr = true })
end
