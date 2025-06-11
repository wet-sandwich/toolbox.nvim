require("toolbox").setup()
require("snippets").setup()

vim.api.nvim_create_user_command("TBIncSemver", function(args)
	require("semver").increment_semantic_version(args.args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TBNpmInstall", function(args)
	require("npm").npm_i(args.args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TBNpmRun", function()
	require("npm").run_script()
end, {})

vim.api.nvim_create_user_command("TBLogVariable", function(args)
	require("logger").log_variable(args.args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TBJson", function(args)
	require("json").json(args.args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("TBDiffChecker", function()
	require("diff").diff_checker()
end, {})

vim.api.nvim_create_user_command("TBFloaterminal", function()
	require("floaterminal").toggle_terminal()
end, {})
