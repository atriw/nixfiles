local lang = require("lib.lang")

return {
  lang.add_treesitter_install("nix"),
  lang.add_lsp_config("nil_ls"),
}
