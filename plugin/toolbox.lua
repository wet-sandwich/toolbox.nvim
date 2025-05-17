vim.api.nvim_create_user_command("TBSemverMajor", function()
	require("semver").increment_semantic_version("major")
end, {})

vim.api.nvim_create_user_command("TBSemverMinor", function()
	require("semver").increment_semantic_version("minor")
end, {})

vim.api.nvim_create_user_command("TBSemverPatch", function()
	require("semver").increment_semantic_version("patch")
end, {})

vim.api.nvim_create_user_command("TBNpmInstall", function()
	require("npm").npm_i()
end, {})

vim.api.nvim_create_user_command("TBNpmInstallPkg", function()
	require("npm").npm_i_pkg()
end, {})
