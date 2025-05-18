local M = {}

---@return string?
local function get_current_path()
	local file_name = vim.fn.expand("%:t")
	local file_path = vim.fn.expand("%:p:h")
	if file_name ~= "package.json" then
		vim.notify("Must be inside a package.json file", vim.log.levels.ERROR)
		return nil
	end
	return file_path
end

---@enum
local modes = {
	all = 1,
	package = 2,
}

-- Run "npm i" from the current file's directory, has two modes, all and package
---@param mode string?
M.npm_i = function(mode)
	mode = mode == "" and "all" or mode
	assert(modes[mode] ~= nil, "Invalid mode selected, valid options [all|package]")
	local path = get_current_path()
	if path == nil then
		return
	end
	local pkg_list = ""
	if modes[mode] == modes.package then
		pkg_list = vim.fn.input("Package(s): ")
	end
	local cmd = string.format("!cd %s && npm i %s", path, pkg_list)
	vim.cmd(cmd)
end

return M
