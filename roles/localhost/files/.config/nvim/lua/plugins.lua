local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
  "neovim/nvim-lspconfig",
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "L3MON4D3/LuaSnip",
  {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
  },
  "williamboman/nvim-lsp-installer",
  "junegunn/fzf",
  "junegunn/fzf.vim",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-telescope/telescope.nvim",
  "windwp/nvim-autopairs",
  "kyazdani42/nvim-web-devicons",
  "sbdchd/neoformat",
  { "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  "sindrets/diffview.nvim",
  "sharksforarms/neovim-rust",
  "ajeetdsouza/zoxide",
  "jvgrootveld/telescope-zoxide",
  {
      'tribela/transparent.nvim',
      event = 'VimEnter',
      config = true,
  },
  "nvim-tree/nvim-tree.lua",
  "hashivim/vim-terraform",
  "tpope/vim-dispatch",
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = true
  },
  {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    "lewis6991/hover.nvim",
  },
  {
    "mcchrish/nnn.vim"
  },
  {
      "zenbones-theme/zenbones.nvim",
      -- Optionally install Lush. Allows for more configuration or extending the colorscheme
      -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
      -- In Vim, compat mode is turned on as Lush only works in Neovim.
      dependencies = "rktjmp/lush.nvim",
      lazy = false,
      priority = 1000,
      -- you can set set configuration options here
      config = function()
        vim.g.zenbones_darken_comments = 45
        vim.cmd.colorscheme('zenbones')
      end
  },
  {
      "water-sucks/darkrose.nvim",
      lazy = false,
      priority = 1000,
      italic = false,
      -- config = function()
      --   vim.cmd.colorscheme('darkrose')
      -- end
  }
})
