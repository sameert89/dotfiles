local M = {}

function M.is_windows()
	local uv = vim.uv or vim.loop
	return uv.os_uname().sysname:find("Windows") ~= nil
end

return M