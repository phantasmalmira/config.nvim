return function()
  require('notify').setup({
    background_colour = '#000000',
    fps = 60,
    stages = 'fade_in_slide_out',
    timeout = 10000,
  })
  require('telescope').load_extension('notify')
end
