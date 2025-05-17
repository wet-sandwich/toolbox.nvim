vim.api.nvim_create_user_command("TBIncSemver", function(args)
	require("semver").increment_semantic_version(args.args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TBNpmInstall", function()
	require("npm").npm_i()
end, {})

vim.api.nvim_create_user_command("TBNpmInstallPkg", function()
	require("npm").npm_i_pkg()
end, {})

vim.api.nvim_create_user_command("TBLogVariable", function(args)
	print(vim.inspect(args))
	require("logger").log_variable(args.args)
end, { nargs = "?" })
