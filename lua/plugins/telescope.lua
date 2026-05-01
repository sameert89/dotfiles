return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local actions = require("telescope.actions")

		require("telescope").setup({
			defaults = {
				file_ignore_patterns = {
					"node_modules",
					"%.git",
					"__pycache__",
					".venv",
					"bin",
					"obj",
					"dist",
					"build",
					"target",
					".svelte-kit",
					".obsidian",
				},
				mappings = {
					i = {
						["<A-v>"] = actions.select_vertical,
						["<A-s>"] = actions.select_horizontal,
						["<A-t>"] = actions.select_tab,
					},
					n = {
						["v"] = actions.select_vertical,
						["s"] = actions.select_horizontal,
						["t"] = actions.select_tab,
					},
				},
			},
		})
	end,
}