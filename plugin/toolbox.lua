vim.api.nvim_create_user_command("TbMajor", function()
	require("semver").increment_semantic_version("major")
end, {})

vim.api.nvim_create_user_command("TbMinor", function()
	require("semver").increment_semantic_version("minor")
end, {})

vim.api.nvim_create_user_command("TbPatch", function()
	require("semver").increment_semantic_version("patch")
end, {})
