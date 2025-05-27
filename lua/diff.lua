-- TODO: add statusline buffer below text windows to display keymaps and other data
local M = {}

---@alias name "old" | "new"

---@class Diff.Buffers
---@field old integer?: The buffer ID for old text buffer
---@field new integer?: The buffer ID for new text buffer

---@class Diff.Windows
---@field old integer?: The window ID for old text window
---@field new integer?: The window ID for new text window

---@class Diff.State
---@field is_diff_on boolean: Whether diffthis has been (or needs to be upon reopening) enabled
---@field cur_win name: The name of the current active window
---@field bufs Diff.Buffers: Buffer id table
---@field wins Diff.Windows: Window id table

---@class Diff.State
local state = {
	is_diff_on = false,
	cur_win = "old",
	bufs = {},
	wins = {},
}

---Returns the buffer IDs, creates new buffers if needed
---@return integer old The buffer ID for the old text buffer
---@return integer new The buffer ID for the new text buffer
local get_bufs_or_create = function()
	if state.bufs.old == nil then
		state.bufs.old = vim.api.nvim_create_buf(false, true)
	end

	if state.bufs.new == nil then
		state.bufs.new = vim.api.nvim_create_buf(false, true)
	end

	return state.bufs.old, state.bufs.new
end

---Create windows for the diff text buffers, save window IDs to state
---@param buf_old integer: The buffer ID of the old text buffer
---@param buf_new integer: The buffer ID of the new text buffer
local create_windows = function(buf_old, buf_new)
	local view_width = math.floor(vim.o.columns * 0.8)
	local ctr = math.floor(vim.o.columns / 2)
	local height = math.floor(vim.o.lines * 0.8)
	local width = math.floor(view_width / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local opts = {
		style = "minimal",
		relative = "editor",
		border = "rounded",
		width = width,
		height = height,
		row = row,
		col = ctr,
	}

	opts.title = "Old"
	opts.anchor = "NE"
	local win_old = vim.api.nvim_open_win(buf_old, true, opts)

	opts.title = "New"
	opts.anchor = "NW"
	local win_new = vim.api.nvim_open_win(buf_new, true, opts)

	state.wins = {
		old = win_old,
		new = win_new,
	}
end

---Get a comma separated list of the window numbers for use with :windo
---@return string
local get_winnr_range = function()
	local first = vim.api.nvim_win_get_number(state.wins.new)
	local last = vim.api.nvim_win_get_number(state.wins.old)
	if first > last then
		first, last = last, first
	end
	return string.format("%d,%d", first, last)
end

---Set the current window to the given window name, defaults to the window stored in state
---@param win name?
local set_win = function(win)
	if win == nil then
		win = state.cur_win
	end
	local id = state.wins[win]
	vim.api.nvim_set_current_win(id)
	state.cur_win = win
end

---Add/remove the text windows from the diff windows
local toggle_diff = function()
	local winnr_range = get_winnr_range()
	local diff_on = state.is_diff_on
	local diff_cmd = diff_on and "diffoff" or "diffthis"
	vim.cmd(winnr_range .. ":windo " .. diff_cmd)
	state.is_diff_on = not diff_on
	set_win()
end

---Close all open diff windows
local close = function()
	pcall(vim.api.nvim_win_close, state.wins.old, true)
	pcall(vim.api.nvim_win_close, state.wins.new, true)
	state.wins = {}
end

M.diff_checker = function()
	if next(state.wins) ~= nil then
		close()
		return
	end

	local buf_old, buf_new = get_bufs_or_create()
	create_windows(buf_old, buf_new)

	if state.is_diff_on then
		local winnr_range = get_winnr_range()
		vim.cmd(winnr_range .. ":windo diffthis")
	end

	-- Set keymaps for old text buffer
	vim.keymap.set("n", "q", close, { buffer = buf_old })
	vim.keymap.set("n", "<C-s>", toggle_diff, { buffer = buf_old })
	vim.keymap.set("n", "<C-l>", function()
		set_win("new")
	end, { buffer = buf_old })

	-- Set keymaps for new text buffer
	vim.keymap.set("n", "q", close, { buffer = buf_new })
	vim.keymap.set("n", "<C-s>", toggle_diff, { buffer = buf_new })
	vim.keymap.set("n", "<C-h>", function()
		set_win("old")
	end, { buffer = buf_new })

	set_win()
end

return M
