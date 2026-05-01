local system = require("functions.system")

local function RunCode()
	if vim.bo.modified then
		vim.cmd("write")
	end

	local filePath = vim.api.nvim_buf_get_name(0)
	local fileType = vim.fn.fnamemodify(filePath, ":e")
	local command = ""
	if fileType == "cpp" then
		local executable = system.is_windows() and ".\\a.exe" or "./a.out"
		command = string.format('g++ "%s" -std=c++20; %s', filePath, executable)
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

return RunCode
