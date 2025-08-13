-- 起動の高速化
pcall(function() vim.loader.enable() end)

-- Bootstrap lazy.nvim
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 基本設定
vim.opt.number = true               -- 行番号を表示
vim.opt.relativenumber = true       -- 相対行番号を表示
vim.opt.expandtab = true            -- タブをスペースに変換
vim.opt.tabstop = 2                 -- タブ幅
vim.opt.shiftwidth = 2              -- インデント幅
vim.opt.smartindent = true          -- 賢いインデント
vim.opt.ignorecase = true           -- 検索時に大文字小文字を区別しない
vim.opt.smartcase = true            -- 大文字が含まれる場合は区別する
vim.opt.clipboard = "unnamedplus"   -- システムクリップボードを使用
vim.opt.termguicolors = true        -- True Colorサポート
vim.opt.signcolumn = "yes"          -- サインカラムを常に表示
vim.opt.wrap = false                -- 折り返さない
vim.opt.scrolloff = 8               -- スクロール時の余白
vim.opt.cursorline = not vim.g.vscode  -- カーソル行をハイライト（VSCode外のみ）
vim.opt.updatetime = 250             -- CursorHoldイベントの待機時間
vim.opt.timeoutlen = 400             -- キーマップのタイムアウト
vim.opt.undofile = true              -- 永続的なundo

-- キーマップ設定
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("i", "jj", "<Esc>", "Exit insert mode")  -- jjでInsertモードを抜ける
map("n", "Y", "y$", "Yank to end of line")    -- Yで行末までヤンク
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- yank時のハイライト
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 250 })
  end,
})

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
    },

    {
      "echasnovski/mini.pairs",
      event = "InsertEnter",
      config = function()
        require("mini.pairs").setup()
      end,
    },

    {
      "kylechui/nvim-surround",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup()
      end,
    },

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

    {
      "folke/which-key.nvim",
      cond = not vim.g.vscode,
      event = "VeryLazy",
      opts = {
        preset = "modern",
        delay = 500,
      },
    },

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
  -- Configure any other settings here. See the documentation for more details.
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
