local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	s("req", fmt("local {} = require('{}')", { i(1), rep(1) })),
	s("todo", fmt("-- TODO: {}", { i(0) })),
	s("module", fmt("local M = {{}}\n\n{}\n\nreturn M", { i(0) })),
}
