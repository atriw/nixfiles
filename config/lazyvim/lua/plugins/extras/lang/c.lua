local lang = require("lib.lang")

return {
  lang.add_treesitter_install("c"),
  {
    "neovim/nvim-lspconfig",
    dependencies = { "p00f/clangd_extensions.nvim" },
    opts = {
      servers = {
        clangd = { mason = false },
      },
      setup = {
        clangd = function(_, opts)
          require("lazyvim.util").lsp.on_attach(function(client, buffer) end)
          require("clangd_extensions").setup()
          return true
        end,
      },
    },
  },
}
