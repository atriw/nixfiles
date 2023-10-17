local lang = require("lib.lang")

return {
  lang.add_treesitter_install("python"),
  lang.add_lsp_config("pylsp"),
}
