-- =====================================================================
-- Bootstrap lazy.nvim
-- =====================================================================

pcall(function() vim.loader.enable() end)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- =====================================================================
-- Leader keys
-- =====================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- =====================================================================
-- Basic options
-- =====================================================================

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.cursorline = not vim.g.vscode
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.undofile = true

-- =====================================================================
-- Keymaps
-- =====================================================================

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("i", "jj", "<Esc>", "Exit insert mode")
map("n", "Y", "y$", "Yank to end of line")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- =====================================================================
-- Autocommands
-- =====================================================================

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 250 })
  end,
})

-- =====================================================================
-- Plugins
-- =====================================================================

require("lazy").setup({
  spec = {
    -- mason.nvim
    {
      "mason-org/mason.nvim",
      opts = {}
    },

    -- mason-lspconfig
    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = {
        { "mason-org/mason.nvim" },
        { "neovim/nvim-lspconfig" },
      },
      opts = {
        ensure_installed = { "intelephense", "lua_ls" }
      },
    },

    -- nvim-lspconfig
    { "neovim/nvim-lspconfig" },

    -- Mini.pairs: Auto pairs
    {
      "echasnovski/mini.pairs",
      event = "InsertEnter",
      config = function()
        require("mini.pairs").setup()
      end,
    },

    -- nvim-telescope: fuzzy finder
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      cond = not vim.g.vscode,
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      },
    },

    -- Treesitter: Better syntax understanding
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      opts = {
        ensure_installed = {
          "bash",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        highlight = {
          enable = not vim.g.vscode,
        },
        indent = { enable = true },
      },
      config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
      end,
    },

    -- Gitsigns: Git diff indicators
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPost", "BufNewFile" },
      opts = {},
    },

    -- Tokyonight: Color scheme
    {
      "folke/tokyonight.nvim",
      cond = not vim.g.vscode,
      lazy = false,
      priority = 1000,
      config = function()
        require("tokyonight").setup({
          style = "night",
        })
        vim.cmd([[colorscheme tokyonight]])
      end,
    },
  },

  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
