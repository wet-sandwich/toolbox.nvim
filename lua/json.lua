-- TODO: add support for visual text selections
local M = {}

local format = function()
	local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local result = vim.system({ "jq", "." }, { stdin = buf_lines }):wait()

	if result.code ~= 0 then
		vim.notify("Error formatting JSON: " .. result.stderr, vim.log.levels.ERROR)
		return
	end

	local lines = vim.fn.split(result.stdout, "\n")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

local parse = function()
	local line = vim.api.nvim_get_current_line()
	if line == "" then
		return
	end
	local result = vim.system({ "jq", "-r" }, { stdin = line }):wait()
	if result.code ~= 0 then
		vim.notify("Error parsing JSON: " .. result.stderr, vim.log.levels.ERROR)
		return
	end
	local lines = vim.fn.split(result.stdout, "\n", false)
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, row - 1, row, false, lines)
end

local stringify = function()
	local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local result = vim.system({ "jq", "tostring" }, { stdin = buf_lines }):wait()

	if result.code ~= 0 then
		vim.notify("Error stringifying JSON: " .. result.stderr, vim.log.levels.ERROR)
		return
	end

	local lines = vim.fn.split(result.stdout, "\n")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

M.json = function(mode)
	if vim.fn.executable("jq") ~= 1 then
		vim.notify(string.format("Must have jq installed to %s JSON", mode), vim.log.levels.ERROR)
		return
	end

	if mode == "format" then
		format()
	elseif mode == "parse" then
		parse()
	elseif mode == "stringify" then
		stringify()
	else
		vim.notify("Invalid mode " .. mode, vim.log.levels.ERROR)
	end
end

return M
