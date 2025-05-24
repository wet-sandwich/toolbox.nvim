local M = {}

local format = function()
	if vim.fn.executable("jq") ~= 1 then
		vim.notify("Must have jq installed to format json", vim.log.levels.ERROR)
		return
	end

	local formatted = ""
	local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local jobid = vim.fn.jobstart({ "jq", "." }, {
		on_stdout = function(_, out, _)
			local str = table.concat(out, "\n")
			if str ~= "" then
				formatted = str
			end
		end,
	})
	vim.fn.chansend(jobid, buf_lines)
	vim.fn.chanclose(jobid, "stdin")

	vim.fn.jobwait({ jobid }, -1)

	local lines = vim.fn.split(formatted, "\n")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

M.json = function(mode)
	if mode == "format" then
		format()
	else
		vim.notify("Invalid mode " .. mode, vim.log.levels.ERROR)
	end
end

return M
