local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

---@param str string
---@return string
local cleanup_string = function(str)
	return str:gsub("\\", ""):match('^"(.*)"$')
end

---@param cmd string: the command to be ran in the terminal
local run_in_split_term = function(cmd)
	vim.cmd("vsplit")

	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(true, true)

	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_set_current_win(win)

	vim.cmd.term()
	vim.api.nvim_chan_send(vim.bo.channel, cmd .. "\r")
end

M.run_script = function()
	local ft = vim.fn.expand("%:e")
	if ft ~= "json" then
		vim.notify("Must be in a JSON file", vim.log.levels.ERROR)
		return
	end

	local scripts = {}
	local query = vim.treesitter.query.parse(
		"json",
		[[
 (pair
   key: (string
     (string_content) @_key (#eq? @_key "scripts"))
   value: (object) @scripts)
  ]]
	)

	local tree = vim.treesitter.get_parser():parse()[1]
	for id, node in query:iter_captures(tree:root(), 0) do
		if node:type() == "object" and query.captures[id] == "scripts" then
			for cnode in node:iter_children() do
				if cnode:type() == "pair" then
					local key_node, value_node = unpack(cnode:named_children())
					local name = vim.treesitter.get_node_text(key_node, vim.api.nvim_get_current_buf())
					local cmd = vim.treesitter.get_node_text(value_node, vim.api.nvim_get_current_buf())
					table.insert(scripts, { cleanup_string(name), cleanup_string(cmd) })
				end
			end
		end
	end

	if #scripts == 0 then
		vim.notify("No scripts found", vim.log.levels.WARN)
		return
	end

	local picker_opts = require("telescope.themes").get_dropdown({})
	pickers
		.new(picker_opts, {
			prompt_title = "scripts",
			finder = finders.new_table({
				results = scripts,
				entry_maker = function(entry)
					return {
						value = entry[2],
						display = entry[1] .. ": " .. entry[2],
						ordinal = entry[1],
					}
				end,
			}),
			sorter = conf.generic_sorter(),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					run_in_split_term(selection.value)
					-- vim.cmd(":TBFloaterminal " .. selection.value)
				end)
				return true
			end,
		})
		:find()
end

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
