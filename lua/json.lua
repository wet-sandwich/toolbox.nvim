local M = {}

local format = function()
	if vim.fn.executable("jq") ~= 1 then
		vim.notify("Must have jq installed to format json", vim.log.levels.ERROR)
		return
	end

	local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local result = vim.system({ "jq", "." }, { stdin = buf_lines }):wait()

	if result.code ~= 0 then
		vim.notify("Error formatting JSON: " .. result.stderr, vim.log.levels.ERROR)
		return
	end

	local lines = vim.fn.split(result.stdout, "\n")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

M.json = function(mode)
	if mode == "format" then
		format()
	else
		vim.notify("Invalid mode " .. mode, vim.log.levels.ERROR)
	end
end

return M
