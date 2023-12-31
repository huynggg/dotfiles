local M = {}

M.general = {
  n = {
    ["<C-d>"] = {"<C-d>zz", "Go down half page, centered"},
    ["<leader>tt"] = {":Twilight <CR>", "Toggle Twilight Focus"},
    ["<C-u>"] = {"<C-u>zz", "Go up half page, centered"}
  }
}

return M
