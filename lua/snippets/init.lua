local ls = require("luasnip")
local lua = require("snippets.lua")
local js = require("snippets.javascript")

local M = {}

M.setup = function()
	ls.add_snippets("lua", lua, { key = "lua" })
	ls.add_snippets("javascript", js, { key = "javascript" })
end

return M
