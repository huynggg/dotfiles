local config = require("plugins.configs.lspconfig")

require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391', 'W291','E501', 'W605'},
          maxLineLength = 100
        }
      }
    }
  }
}
