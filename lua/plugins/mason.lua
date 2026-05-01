return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},

	{
		"neovim/nvim-lspconfig",
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls",
				-- "rust_analyzer", -- rustaceanvim handles this
				"ts_ls",
				"clangd",
				"svelte",
				"pyright",
				"tailwindcss",
			},
			automatic_enable = true,
		},
	},
}
