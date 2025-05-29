---@class Toolbox.Json
local M = {}

-- Get the selected lines (or entire buffer) and the cursor positions for the selection
---@return string[]
---@return integer[]
local get_lines_and_pos = function()
	local mode = vim.fn.mode()

	-- character selection
	if mode == "v" then
		local _, row1, col1, _ = unpack(vim.fn.getpos("."))
		local _, row2, col2, _ = unpack(vim.fn.getpos("v"))

		if row2 < row1 then
			row1, row2 = row2, row1
			col1, col2 = col2, col1
		elseif row1 == row2 and col2 < col1 then
			col1, col2 = col2, col1
		end

		local lines = vim.api.nvim_buf_get_text(0, row1 - 1, col1 - 1, row2 - 1, col2, {})
		return lines, { row1, col1, row2, col2 }
	end

	-- line selection
	if mode == "V" then
		local _, row1, _, _ = unpack(vim.fn.getpos("."))
		local _, row2, _, _ = unpack(vim.fn.getpos("v"))

		if row2 < row1 then
			row1, row2 = row2, row1
		end

		local lines = vim.api.nvim_buf_get_lines(0, row1 - 1, row2, false)
		return lines, { row1, -1, row2, -1 }
	end

	-- not in visual mode, select entire buffer
	local row1 = 1
	local row2 = -1

	local lines = vim.api.nvim_buf_get_lines(0, row1 - 1, row2, false)
	return lines, { row1, -1, row2, -1 }
end

-- Insert the lines at the given position based on selection type
---@param lines string[]
---@param pos integer[]
local write_lines = function(lines, pos)
	local row1, col1, row2, col2 = unpack(pos)

	if col1 == -1 then
		-- line selection or entire buffer
		vim.api.nvim_buf_set_lines(0, row1 - 1, row2, false, lines)
	else
		-- character selection
		vim.api.nvim_buf_set_text(0, row1 - 1, col1 - 1, row2 - 1, col2, lines)
	end

	-- exit visual mode if in it
	local key = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
	vim.api.nvim_feedkeys(key, "n", false)
end

local format = function()
	local lines, pos = get_lines_and_pos()

	if #lines == 0 then
		return
	end

	local result = vim.system({ "jq", "." }, { stdin = lines }):wait()

	if result.code ~= 0 then
		vim.notify("Error formatting JSON: " .. result.stderr, vim.log.levels.ERROR)
		return
	end

	local result_lines = vim.fn.split(result.stdout, "\n")
	write_lines(result_lines, pos)
end

local parse = function()
	local lines, pos = get_lines_and_pos()

	if #lines == 0 then
		return
	end

	local parse_result = vim.system({ "jq", "-r" }, { stdin = lines }):wait()

	if parse_result.code ~= 0 then
		vim.notify("Error parsing JSON: " .. parse_result.stderr, vim.log.levels.ERROR)
		return
	end

	local format_result = vim.system({ "jq", "." }, { stdin = parse_result.stdout }):wait()

	if format_result.code ~= 0 then
		vim.notify("Error parsing JSON: " .. format_result.stderr, vim.log.levels.ERROR)
		return
	end

	local result_lines = vim.fn.split(format_result.stdout, "\n")
	write_lines(result_lines, pos)
end

local stringify = function()
	local lines, pos = get_lines_and_pos()
	local result = vim.system({ "jq", "tostring" }, { stdin = lines }):wait()

	if result.code ~= 0 then
		vim.notify("Error stringifying JSON: " .. result.stderr, vim.log.levels.ERROR)
		return
	end

	local result_lines = vim.fn.split(result.stdout, "\n")
	write_lines(result_lines, pos)
end

---@alias mode "format" | "parse" | "stringify"

---@param mode mode
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
