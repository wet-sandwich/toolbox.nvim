vim.api.nvim_create_user_command("TBSemverMajor", function()
	require("semver").increment_semantic_version("major")
end, {})

vim.api.nvim_create_user_command("TBSemverMinor", function()
	require("semver").increment_semantic_version("minor")
end, {})

vim.api.nvim_create_user_command("TBSemverPatch", function()
	require("semver").increment_semantic_version("patch")
end, {})
