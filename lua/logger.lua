local config = require("toolbox").config.logger

local M = {}

--- Get the print statement based on the filetype and log level
--- @param level string
---@return string?
local function get_print_cmd(level)
	local ft = vim.fn.expand("%:e")
	ft = config.language_map[ft] or ft

	local cmd = config.print_statements[ft]
	if cmd == nil then
		local msg = string.format("No print statement found for filetype %s", ft)
		vim.notify(msg, vim.log.levels.ERROR)
		return nil
	end

	if type(cmd) == "string" then
		return cmd
	end

	cmd = cmd[level]
	if cmd == nil then
		local msg = string.format("No print statement found for filetype %s with level %s", ft, level)
		vim.notify(msg, vim.log.levels.ERROR)
		return nil
	end

	return cmd
end

--- TODO: see if treesitter can be used to confirm if the current word is a variable
--- TODO: add support for objects
--- Inserts a print statement line to log the variable under the cursor
---@param level string
M.log_variable = function(level)
	level = level == "" and "info" or level
	local var = vim.fn.expand("<cword>")
	local print_cmd = get_print_cmd(level)

	if print_cmd == nil then
		return
	end

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local new_line = string.format('%s("%s%s:", %s)', print_cmd, config.prefix, var, var)
	vim.api.nvim_buf_set_lines(0, row, row, false, { new_line })
	vim.api.nvim_feedkeys("=j", "n", false)
end

return M
