vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local RunCode = require("functions.run_code")

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
map("n", "<leader>run", RunCode, { noremap = true })
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

-- Don't fat finger the macro button
vim.keymap.set("n", "q", "<Nop>", { desc = "Disabled macro recording" })
vim.keymap.set("n", "<leader>q", "q", {
	remap = true,
	desc = "Start/stop macro recording",
})

-- Doc generations
vim.keymap.set("n", "<leader>docf", function()
    require("neogen").generate({ type = "func" })
end, { desc = "Generate function docs" })

vim.keymap.set("n", "<leader>docc", function()
    require("neogen").generate({ type = "class" })
end, { desc = "Generate class docs" })

vim.keymap.set("n", "<leader>docF", function()
    require("neogen").generate({ type = "file" })
end, { desc = "Generate file docs" })
