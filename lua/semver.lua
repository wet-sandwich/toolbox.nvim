local M = {}

-- Functions for quickly incrementing a semantic version

---@class position
---@field begins integer
---@field ends integer

---@class version
---@field major integer
---@field minor integer
---@field patch integer

--- Searches the current line for a semantic version string
--- Returns the version string's start and end position and the three version values
---@overload fun(): position?, version?
local function parse_version()
	local line = vim.api.nvim_get_current_line()
	local begins, ends, major, minor, patch = line:find("(%d+)%.(%d+)%.(%d+)", 1)

	if begins == nil then
		print("No semantic version found on this line")
		return nil, nil
	end

	local pos = { begins = begins, ends = ends }
	local version = { major = major, minor = minor, patch = patch }
	return pos, version
end

--- Overwrites the current semantic version in the line with the new one
---@param pos position
---@param ver version
local function write_new_version(pos, ver)
	local line = vim.api.nvim_get_current_line()
	local new_version = string.format("%d.%d.%d", ver.major, ver.minor, ver.patch)
	local new_line = line:sub(1, pos.begins - 1) .. new_version .. line:sub(pos.ends + 1, -1)
	vim.api.nvim_set_current_line(new_line)
end

M.major = function()
	local inc = vim.v.count1
	local pos, ver = parse_version()
	if pos == nil or ver == nil then
		return
	end
	ver.major, ver.minor, ver.patch = ver.major + inc, 0, 0
	write_new_version(pos, ver)
end

M.minor = function()
	local inc = vim.v.count1
	local pos, ver = parse_version()
	if pos == nil or ver == nil then
		return
	end
	ver.minor, ver.patch = ver.minor + inc, 0
	write_new_version(pos, ver)
end

M.patch = function()
	local inc = vim.v.count1
	local pos, ver = parse_version()
	if pos == nil or ver == nil then
		return
	end
	ver.patch = ver.patch + inc
	write_new_version(pos, ver)
end

return M
