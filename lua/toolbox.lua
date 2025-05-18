local M = {}

local defaults = {
	logger = {
		language_map = {
			jsx = "js",
			ts = "js",
			tsx = "js",
		},
		print_statements = {
			js = {
				debug = 'console.debug("%s:", %s)',
				info = 'console.log("%s:", %s)',
				warn = 'console.warn("Warning! %s:", %s)',
				error = 'console.error("Error! %s:", %s)',
			},
			lua = {
				info = 'print("%s:", %s)',
			},
		},
	},
}

---@class Toolbox.LoggerOpts
---@field language_map table<string, string>: Map filetypes to a language (useful for filetypes that differ from the standard language)
---@field print_statements table<string, string>: Table of print statements for different filetypes and log levels

---@class Toolbox.Options
---@field logger Toolbox.LoggerOpts

---@class Toolbox.Options
M.config = {
	logger = {
		language_map = {},
		print_statements = {},
	},
}

---@param opts table?
M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", defaults, opts or {})
end

return M
