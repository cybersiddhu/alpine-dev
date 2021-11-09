require("treesitter-context").setup{
	enable = true,
	throttle = true,
	max_lines = 0,
	pattern = {
		default = {"class","function","method"},
	},
}
