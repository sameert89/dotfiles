-- Before All
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Key Maps
-- Telescope
local map = vim.keymap.set;
map("n", "<leader>tf", ":NvimTreeToggle<CR>", { noremap = true })
map("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true })
map("n", "<leader>lg", ":Telescope live_grep<CR>", { noremap = true })
map("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true })
-- Diagnostics
map("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>d", vim.diagnostic.setloclist, { desc = "Diagnostics list" })
-- Terminal Mode Escape
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
-- FloatTerm
map("n", "<leader>tt", ":FloatermToggle<CR>", { noremap = true })
-- Copilot Chat
map("n",  "<leader>cop", ":CodeCompanionChat Toggle<CR>", { noremap = true })
-- Code Runner
local RunCodeWrapper = function() return RunCode() end -- Wrapper since RunCode is defined at the end
map("n", "<leader>run", RunCodeWrapper, { noremap = true })
-- LSP Keymaps
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
-- Other Keymaps
-- Ctrl + Backspace to delete word (Only works on PowerShell)
map('i', '<C-H>', '<C-w>', { noremap = true, silent = true })
-- Reload vim config
map('n', '<leader>sv', ':source $MYVIMRC<CR>')
-- Splits
-- Movement
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
-- Closing
map("n", "<C-q>", "<cmd>close<CR>", { desc = "Close split" })

-- Buffer Navigation
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Creating Files
map("n", "<leader>nf", function()
	local current_dir = vim.fn.expand("%:p:h")
	local name = vim.fn.input("New file: ", current_dir .. "/", "file")

	if name == "" then
		return
	end

	local dir = vim.fn.fnamemodify(name, ":p:h")
	vim.fn.mkdir(dir, "p")
	vim.cmd.edit(vim.fn.fnameescape(name))
end, { desc = "New file in the Same location as current file" })

-- Mixed move/rename
map("n", "<leader>rn", function()
	local old_name = vim.fn.expand("%:p")
	local new_name = vim.fn.input("Rename to: ", old_name, "file")

	if new_name == "" or new_name == old_name then
		return
	end

	local new_dir = vim.fn.fnamemodify(new_name, ":p:h")
	vim.fn.mkdir(new_dir, "p")

	vim.cmd.saveas(vim.fn.fnameescape(new_name))
	vim.fn.delete(old_name)
end, { desc = "Rename current file" })

-- Remap Macro recording so I don't fat-finger it
vim.keymap.set("n", "q", "<Nop>", { desc = "Disabled macro recording" })

vim.keymap.set("n", "<leader>q", function()
  vim.cmd.normal({ "q", bang = true })
end, { desc = "Start/stop macro recording" })

-- LSP hints (Requires 0.10+)
vim.lsp.inlay_hint.enable(true, { 0 })
-- Create a New File


-- Vim Specific Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-- Setup Powershell (Copied for stackoverflow, I have no idea how this works)
local isWin = vim.loop.os_uname().sysname:find 'Windows' and true or false
if isWin then
	if vim.fn.executable("pwsh") == 1 then
		vim.opt.shell = "pwsh.exe" --"pwsh" for 7.x if installed
	else
		vim.opt.shell = "powershell" --"powershell" for 5.x
	end
	vim.o.shellxquote = ''
	vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
	vim.o.shellquote = ''
	vim.o.shellpipe = '| Out-File -Encoding UTF8 %s'
	vim.o.shellredir = '| Out-File -Encoding UTF8 %s`'
end

-- Highlight on Yank
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('highlight on yank', { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ "MeanderingProgrammer/render-markdown.nvim" },
		{ "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate", version = "0.10.0" },
		{ "neovim/nvim-lspconfig" },
		{ "mrcjkb/rustaceanvim", version = "^6", lazy = false },
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"saadparwaiz1/cmp_luasnip",
			},
		},
		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" }
		},
		{ "nvim-tree/nvim-tree.lua" }, -- optional file explorer
		{ "tpope/vim-surround" }, -- cs<what><to-what>
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		}, -- this auto closes stuff
		{ "tpope/vim-commentary" }, -- select then gc to comment visual mode selectgion
		{ "voldikss/vim-floaterm" },
		{ "github/copilot.vim" },
		{ "sameert89/dotenv.nvim" },
		{ "olimorris/codecompanion.nvim", version = "v17.33.0" },
		{ "mason-org/mason.nvim", opts = {} },
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {},
			dependencies = {
				{ "mason-org/mason.nvim" },
				{ "neovim/nvim-lspconfig" },
			},
		},
		{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
		-- This shows keybinds
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
		},
		-- This fixes undefined global 'vim' in init.lua
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		-- Saves sessions
		{
			"gennaro-tedesco/nvim-possession",
			dependencies = {
				"ibhagwan/fzf-lua",
			},
			config = true,
			keys = {
				{ "<leader>sl", function() require("nvim-possession").list() end, desc = "📌list sessions", },
				{ "<leader>sn", function() require("nvim-possession").new() end, desc = "📌create new session", },
				{ "<leader>su", function() require("nvim-possession").update() end, desc = "📌update current session", },
				{ "<leader>sd", function() require("nvim-possession").delete() end, desc = "📌delete selected session"},
			},
		},
		-- themes and customizations
		-- { "catppuccin/nvim", name = "catppuccin", priority = 1001 },
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{
			"oskarnurm/koda.nvim",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
		}
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
})

-- Plugin Specific Setup

-- Color Scheme
-- require("catppuccin").setup({
-- 	auto_integrations = true,
-- 	flavour = "mocha",
-- 	transparent_background = false,
-- 	custom_highlights = {
-- 		NormalFloat = { bg = "none" },
-- 		TelescopeBorder = { bg = "none" }
-- 	}
-- })
vim.cmd.colorscheme("koda")

-- Transparent Background
-- vim.cmd [[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]]

-- Suppress Intro Message
vim.cmd("set shortmess+=I")

-- Completion
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},

	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" },
	}),
})

-- Custom LuaSnip Snippets
require("luasnip.loaders.from_lua").lazy_load({
	paths = "~/.config/nvim/snippets/"
})

-- File Tree
require("nvim-tree").setup()

-- Telescope
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
			".obsidian"
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
	}
})

-- Treesitter syntax highlight
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"rust",
		"cpp",
		"python",
		"javascript",
		"typescript",
		"go",
		"html",
		"css",
		"json",
		"yaml",
		"bash",
		"svelte",
		"tsx",
		"markdown",
		"markdown_inline",
		"typst"
	},
	highlight = { enable = true },
	indent = { enable = true },
})

-- env file setup
local dotenv = require('dotenv')

-- Code Companion
require("codecompanion").setup({
	adapters = {
		http = {
			tavily = function()
				return require("codecompanion.adapters").extend("tavily", {
					env = {
						api_key = dotenv.get("TAVILY_API_KEY")
					},
				})
			end,
			openai_gpt54mini = function()
				return require("codecompanion.adapters").extend("openai"), {
					env = {
						api_key = dotenv.get("OPENAI_API_KEY")
					},
					schema = {
						model = {
							default = "gpt-5.4mini"
						}
					}
				}
			end,
			openrouter_grok = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					env = {
						url = "https://openrouter.ai/api",
						api_key = dotenv.get("OPENROUTER_API_KEY"),
						chat_url = "/v1/chat/completions",
					},
					schema = {
						model = {
							default = "x-ai/grok-code-fast-1",
						},
					},
				})
			end
		},
	},
	strategies = {
		chat = {
			-- adapter = "openrouter_grok"
			adapter = "openai_gpt54mini"
		},
		inline = {
			-- adapter = "openrouter_grok"
			adapter = "openai_gpt54mini"
		},
		cmd = {
			-- adapter = "openrouter_grok"
			adapter = "openai_gpt54mini"
		}

	},
	display = {
		chat = {
			intro_message = "Hey! how can I help?",
			window = {
				layout = "vertical",
				height = 0.8,
				width = 0.25,
				position = "right"
			}
		}
	}})


-- Mason + LSP Setup
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		-- "rust_analyzer", -- rustaceanvim handles this
		"ts_ls",
		"clangd",
		"svelte",
		"pyright",
		"tailwindcss"
	},
	automatic_enable = true -- this calls vim.lsp.enable for all the servers
})

-- Lualine
require('lualine').setup {
	options = {
		theme = "auto",
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = {
			{ 'filename' },
			{
				require("nvim-possession").status,
				cond = function()
					return require("nvim-possession").status() ~= nil
				end,
			}
		},
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{ 'filename' },
			{
				require("nvim-possession").status,
				cond = function()
					return require("nvim-possession").status() ~= nil
				end,
			}
		},
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {},
	},
}

-- Render Markdown
require('render-markdown').setup({
	file_types = { "markdown", "codecompanion" },
	opts = {
		render_modes = true, -- Render in ALL modes
		sign = {
			enabled = false, -- Turn off in the status column
		},
	},
	completions = { lsp = { enabled = true } },
})

-- Possession 
require("nvim-possession").setup({
	autoload = true,
	autosave = false
})

-- CUSTOM FUNCTIONS --
RunCode = function()
	if vim.bo.modified then
		vim.cmd("write")
	end

	local filePath = vim.api.nvim_buf_get_name(0)
	local fileType = vim.fn.fnamemodify(filePath, ":e")
	local command = ""
	if fileType == "cpp" then
		command = string.format('g++ "%s" -std=c++20; .\\a.exe', filePath)
	elseif fileType == "py" then
		command = string.format('python "%s"', filePath)
	elseif fileType == "rs" then
		command = 'cargo run'
	else
		vim.notify("Unsupported filetype: " .. fileType, vim.log.levels.WARN)
		return
	end
	vim.cmd("FloatermToggle runner_term")
	vim.cmd(string.format('FloatermSend --name=runner_term %s', command))
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), 'n', false);
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("G", true, false, true), 'n', false);
end
