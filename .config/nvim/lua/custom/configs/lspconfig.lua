local config = require("plugins.configs.lspconfig")

require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391', 'W291'},
          maxLineLength = 100
        }
      }
    }
  }
}
