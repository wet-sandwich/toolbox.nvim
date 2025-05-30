local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
-- local rep = require("luasnip.extras").rep

return {
	s(
		"log",
		fmt([[console.{}(`{}`{})]], {
			c(1, { t("log"), t("debug"), t("warn"), t("error") }),
			i(2),
			c(3, { t(""), fmt(", {}", i(1)) }),
		})
	),
	s(
		"try",
		fmt(
			[[
    try {{
      {}
    }} catch (error) {{
      console.error(`{}`, error)
    }}
    ]],
			{
				i(2),
				i(1),
			}
		)
	),
}
