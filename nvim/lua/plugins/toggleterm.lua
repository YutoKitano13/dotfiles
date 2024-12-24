return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[<leader>t]],
      direction = "horizontal",
      float_opts = {
        border = "curved",
      },
    },
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
    },
  },
}
