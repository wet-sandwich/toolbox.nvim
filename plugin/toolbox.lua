require("toolbox").setup()

vim.api.nvim_create_user_command("TBIncSemver", function(args)
	require("semver").increment_semantic_version(args.args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TBNpmInstall", function(args)
	require("npm").npm_i(args.args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TBLogVariable", function(args)
	require("logger").log_variable(args.args)
end, { nargs = "?" })
