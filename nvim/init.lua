-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Load keymaps
require("config.keymaps")

-- vscode
if vim.g.vscode then
  vim.diagnostic.enable(false)
end