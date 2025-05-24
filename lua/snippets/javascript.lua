local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local same = function(index)
	return f(function(arg)
		return arg[1]
	end, index)
end

return {
	-- TODO figure out why the function node input doesn't update until after input is complete
	s("log", fmt([[console.log("{}", {})]], { i(1), same(1) })),
}
