local M = {}

local defaults = {
	logger = {
		prefix = "",
		print_statements = {
			js = {
				debug = "console.debug",
				info = "console.log",
				warn = "console.warn",
				error = "console.error",
			},
			lua = "print",
		},
	},
}

---@class Toolbox.LoggerOpts
---@field prefix string: The text to prefix the log message (to quickly identify your logs)
---@field print_statements string|table<string, string>: The print statements for different filetypes

---@class Toolbox.Options
---@field logger Toolbox.LoggerOpts

---@class Toolbox.Options
M.config = {
	logger = {
		prefix = "",
		print_statements = {},
	},
}

---@param opts table?
M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", defaults, opts or {})
end

return M
