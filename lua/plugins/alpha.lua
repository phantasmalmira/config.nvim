return {
	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.buttons.val = {
				dashboard.button("n", "  > New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("p", "  > Projects", ":Telescope projects<CR>"),
				dashboard.button("f", "  > Find files", ":Telescope find_files<CR>"),
				dashboard.button("g", "  > Grep files", ":Telescope live_grep<CR>"),
				dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
				dashboard.button("l", "  > Lazy", ":Lazy<CR>"),
			}
			return dashboard.opts
		end,
	},
}
