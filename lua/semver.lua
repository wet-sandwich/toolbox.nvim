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
--- Returns the start and end indices of the version string and the three version values
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

--- Overwrites the current semantic version in the current line with the new version
---@param pos position
---@param ver version
local function write_new_version(pos, ver)
	local line = vim.api.nvim_get_current_line()
	local new_version = string.format("%d.%d.%d", ver.major, ver.minor, ver.patch)
	local new_line = line:sub(1, pos.begins - 1) .. new_version .. line:sub(pos.ends + 1, -1)
	vim.api.nvim_set_current_line(new_line)
end

---@type table<string, function>
local incrementer = {
	---@overload fun(ver: version, inc: integer): version
	major = function(ver, inc)
		ver.major, ver.minor, ver.patch = ver.major + inc, 0, 0
		return ver
	end,

	---@overload fun(ver: version, inc: integer): version
	minor = function(ver, inc)
		ver.minor, ver.patch = ver.minor + inc, 0
		return ver
	end,

	---@overload fun(ver: version, inc: integer): version
	patch = function(ver, inc)
		ver.patch = ver.patch + inc
		return ver
	end,
}

---@param type string
M.increment_semantic_version = function(type)
	local inc = vim.v.count1
	local pos, ver = parse_version()
	if pos == nil or ver == nil then
		return
	end
	ver = incrementer[type](ver, inc)
	write_new_version(pos, ver)
end

return M
