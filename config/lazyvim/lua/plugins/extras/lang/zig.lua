local lang = require("lib.lang")

return {
  lang.add_treesitter_install("zig"),
  lang.add_lsp_config("zls"),
}
