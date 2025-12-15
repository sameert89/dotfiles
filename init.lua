-- Before All
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Key Maps
-- Telescope
vim.keymap.set("n", "<leader>tf", ":NvimTreeToggle<CR>", { noremap = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true })
vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true })
-- Diagnostics
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics list" })
-- Terminal Mode Escape
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
-- FloatTerm
vim.keymap.set("n", "<leader>tt", ":FloatermToggle<CR>", { noremap = true })
-- Copilot Chat
vim.keymap.set("n",  "<leader>cop", ":CodeCompanionChat Toggle<CR>", { noremap = true })
-- Code Runner
local RunCodeWrapper = function() return RunCode() end -- Wrapper since RunCode is defined at the end
vim.keymap.set("n", "<leader>run", RunCodeWrapper, { noremap = true })


-- Vim Specific Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Setup Powershell (Copied for stackoverflow, I have no idea how this works)
local isWin = vim.loop.os_uname().sysname:find 'Windows' and true or false
if isWin then
    if vim.fn.executable("pwsh") == 1 then
        vim.opt.shell = "pwsh" --"pwsh" for 7.x if installed
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
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
		{ "neovim/nvim-lspconfig" },
		{ 'mrcjkb/rustaceanvim', version = '^6', lazy = false },
		{ "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "saadparwaiz1/cmp_luasnip" } },
		{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
		{ "nvim-tree/nvim-tree.lua" }, -- optional file explorer
		{ "tpope/vim-surround" },  -- cs<what><to-what>
		{ "windwp/nvim-autopairs", event = "InsertEnter", config = true }, -- this auto closes stuff
		{ "tpope/vim-commentary" }, -- select then gc to comment visual mode selectgion 
		{ "voldikss/vim-floaterm" },
		{ "github/copilot.vim" },
		{ "sameert89/dotenv.nvim" },
		{ "olimorris/codecompanion.nvim", version = "v17.33.0" },
		{ "mason-org/mason.nvim", opts = {} },
		{ "mason-org/mason-lspconfig.nvim", opts = {}, dependencies = {{ "mason-org/mason.nvim" }, { "neovim/nvim-lspconfig" }},
		{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp"}},
		-- themes and customizations
		{ "catppuccin/nvim", name = "catppuccin", priority = 1001 },
		{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } }
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false }
})

-- Plugin Specific Setup

-- Color Scheme
require("catppuccin").setup({
	auto_integrations = true,
	flavour = "macchiato"
})
vim.cmd.colorscheme("catppuccin")

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
  paths = "~/AppData/Local/nvim/snippets/"
})

-- File Tree
require("nvim-tree").setup()

-- Telescope
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
	},
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
						api_key = dotenv.get("TAVILY_API_KEY"),
					},
				})
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
			adapter = "openrouter_grok"
		},
		inline = {
			adapter = "openrouter_grok"
		},
		cmd = {
			adapter = "openrouter_grok"
		}
	},
	display = {
		chat = {
			intro_message = "Hello! How can I help spice things up? 😉",
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
		theme = "catppuccin",
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {},
	},
}

-- Render Markdown
require('render-markdown').setup({
	ft = { "markdown", "codecompanion" },
	opts = {
		render_modes = true, -- Render in ALL modes
		sign = {
			enabled = false, -- Turn off in the status column
		},
	},
	completions = { lsp = { enabled = true } },
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
		command = string.format('g++ "%s"; .\\a.exe', filePath)
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
