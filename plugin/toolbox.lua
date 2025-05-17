vim.api.nvim_create_user_command("TBIncSemver", function(args)
	require("semver").increment_semantic_version(args.fargs[1])
end, { nargs = "?" })

vim.api.nvim_create_user_command("TBNpmInstall", function()
	require("npm").npm_i()
end, {})

vim.api.nvim_create_user_command("TBNpmInstallPkg", function()
	require("npm").npm_i_pkg()
end, {})
