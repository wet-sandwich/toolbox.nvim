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

-- Run "npm i" from the current file's directory
M.npm_i = function()
	local path = get_current_path()
	if path == nil then
		return
	end
	vim.cmd("!cd " .. path .. " && npm i")
end

-- Run "npm i <package>" from the current file's directory
-- prompts user for package name
M.npm_i_pkg = function()
	local path = get_current_path()
	if path == nil then
		return
	end
	local pkg = vim.fn.input("Package(s): ")
	vim.cmd("!cd " .. path .. " && npm i " .. pkg)
end

return M
