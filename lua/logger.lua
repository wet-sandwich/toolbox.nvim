local config = require("toolbox").config.logger

local M = {}

--- Get the print statement based on the filetype and log level
--- @param level string
---@return string?
local function get_print_cmd(level)
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.filetype.match({ buf = buf })

	ft = config.language_map[ft] or ft
	local cmd = config.print_statements[ft]

	if cmd == nil then
		local msg = string.format("No print statement found for filetype %s", ft)

		vim.notify(msg, vim.log.levels.ERROR)

		return nil
	end

	cmd = cmd[level]

	if cmd == nil then
		local msg = string.format("No print statement found for filetype %s with log level %s", ft, level)

		vim.notify(msg, vim.log.levels.ERROR)

		return nil
	end

	return cmd
end

local function get_word_or_selection()
	local mode = vim.fn.mode()
	if mode == "v" then
		local _, row1, col1, _ = unpack(vim.fn.getpos("."))
		local _, row2, col2, _ = unpack(vim.fn.getpos("v"))
		assert(row1 == row2, "Selection must be on a single line")
		if col2 < col1 then
			col1, col2 = col2, col1
		end
		local line = vim.fn.getline(row1)
		local selection = string.sub(line, col1, col2)
		return selection
	end
	return vim.fn.expand("<cword>")
end

--- Inserts a print statement line to log the variable under the cursor
---@param level string
M.log_variable = function(level)
	level = level == "" and "info" or level
	local var = get_word_or_selection()
	local print_cmd = get_print_cmd(level)

	if print_cmd == nil then
		return
	end

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local new_line = string.gsub(print_cmd, "%%s", var)
	vim.api.nvim_buf_set_lines(0, row, row, false, { new_line })
	vim.api.nvim_feedkeys("=j", "n", false)
end

return M
