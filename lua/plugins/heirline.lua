return {
	{
		"rebelot/heirline.nvim",
		opts = function()
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
				},
				init = function(self)
					self.mode = vim.fn.mode(1)
				end,
				provider = function(self)
					return self.mode_names[self.mode]
				end,
			}

			local StatusLine = { Mode }
			local WinBar = {}
			local TabLine = {}
			local StatusColumn = {}

			return {
				statusline = StatusLine,
			}
		end,
	},
}
