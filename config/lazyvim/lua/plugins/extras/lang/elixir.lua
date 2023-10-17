local lang = require("lib.lang")

return {
  lang.add_treesitter_install("elixir"),
  lang.add_lsp_config("elixirls", { cmd = { "elixir-ls" } }),
}
