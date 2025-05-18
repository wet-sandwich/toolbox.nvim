local M = {}

local defaults = {
	logger = {
		prefix = "",
		language_map = {
			jsx = "js",
			ts = "js",
			tsx = "js",
		},
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
---@field language_map table<string, string>: Map filetypes to a language (useful for filetypes that differ from the standard language)
---@field print_statements string|table<string, string>: The print statements for different filetypes

---@class Toolbox.Options
---@field logger Toolbox.LoggerOpts

---@class Toolbox.Options
M.config = {
	logger = {
		prefix = "",
		language_map = {},
		print_statements = {},
	},
}

---@param opts table?
M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", defaults, opts or {})
end

return M
