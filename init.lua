require("core.options")
require("core.keymaps")
require("core.autocmds")
require("config.lazy")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
})
