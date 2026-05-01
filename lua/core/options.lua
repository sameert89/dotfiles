vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
-- supress intro message
vim.cmd("set shortmess+=I")

local system = require("functions.system")

-- Setup Powershell (Copied for stackoverflow, I have no idea how this works)
local isWin = system.is_windows()

if isWin then
	local shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"

	vim.opt.shell = shell
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
	vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
	vim.opt.shellpipe = "| Out-File -Encoding UTF8 %s"
	vim.opt.shellredir = "| Out-File -Encoding UTF8 %s"

	vim.g.floaterm_shell = shell .. " -NoLogo"
end

vim.lsp.inlay_hint.enable(true, { 0 })
