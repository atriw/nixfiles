local lang = require("lib.lang")

return {
  lang.add_treesitter_install("haskell"),
  lang.add_lsp_config("hls"),
}
