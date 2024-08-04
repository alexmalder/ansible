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
  "mfussenegger/nvim-jdtls",
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
  "frazrepo/vim-rainbow",
  "kyazdani42/nvim-web-devicons",
  "bfrg/vim-cpp-modern",
  "vim-autoformat/vim-autoformat",
  "sbdchd/neoformat",
  { "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  "sindrets/diffview.nvim",
  "sharksforarms/neovim-rust",
  "ajeetdsouza/zoxide",
  "jvgrootveld/telescope-zoxide",
  "xiyaowong/nvim-transparent",
  "water-sucks/darkrose.nvim",
  "neg-serg/neg.nvim",
  "nvim-tree/nvim-tree.lua",
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
  },
  "hashivim/vim-terraform",
  "tpope/vim-dispatch",
  "bluz71/vim-moonfly-colors",
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },
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
  }
})
