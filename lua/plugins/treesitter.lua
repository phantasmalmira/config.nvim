return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		},
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
