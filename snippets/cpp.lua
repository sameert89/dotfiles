local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("cp", {
    t({
      "#include <bits/stdc++.h>",
      "using namespace std;",
      "using vi = vector<int>;",
      "using vvi = vector<vector<int>>;",
      "using pi = pair<int, int>;",
      "using ll = long long;",
      "",
      "class Solution {",
      "public:",
      "    void solve() {",
      "        ",
    }),
    i(1, "code"),
    t({
      "",
      "    }",
      "};",
      "",
      "int main() {",
      "    ios::sync_with_stdio(false);",
      "    cin.tie(nullptr);",
      "    cout.tie(nullptr);",
      "    // freopen(\"name.in\", \"r\", stdin);",
      "    // freopen(\"name.out\", \"w\", stdout);",
      "    Solution s;",
      "    s.solve();",
      "    return 0;",
      "}",
    }),
  }),

  s("valid_neighbors", {
    t({
      "vector<pair<int, int>> valid_neighbors(int x, int y, vector<vector<int>> &graph) {",
      "    vector<pair<int, int>> neighbors;",
      "    vector<pair<int, int>> delta{{0, -1}, {-1, 0}, {0, 1}, {1, 0}};",
      "    int m = graph.size(), n = graph[0].size();",
      "    for (auto const &[dx, dy] : delta) {",
      "        int r = x + dx, c = y + dy;",
      "        if (r >= 0 && r < m && c >= 0 && c < n)",
      "            neighbors.push_back({r, c});",
      "    }",
      "    return neighbors;",
      "}",
    }),
  }),
}
