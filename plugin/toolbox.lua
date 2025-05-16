vim.api.nvim_create_user_command("TbMajor", function()
	require("semver").major()
end, {})

vim.api.nvim_create_user_command("TbMinor", function()
	require("semver").minor()
end, {})

vim.api.nvim_create_user_command("TbPatch", function()
	require("semver").patch()
end, {})
