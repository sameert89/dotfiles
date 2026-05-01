local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  s("code_block", {
    t("```"),
    i(1, "lang"),
    t({ "", "" }),
    i(2, "code"),
    t({ "", "```" }),
  }),
}
