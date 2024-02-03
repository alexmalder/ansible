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

require("lazy").setup(
  {
     "neovim/nvim-lspconfig",
     "hrsh7th/nvim-compe",
     --"L3MON4D3/LuaSnip",
     --"hrsh7th/nvim-cmp",
     --"saadparwaiz1/cmp_luasnip",
     --"hrsh7th/cmp-nvim-lsp",
     --"hrsh7th/cmp-buffer",
     --"hrsh7th/cmp-path",
     --"hrsh7th/cmp-cmdline",
     --"hrsh7th/cmp-nvim-lsp-signature-help",
     "kkharji/lspsaga.nvim",
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
    {"romgrk/barbar.nvim",
      dependencies = {
        "lewis6991/gitsigns.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      opts = { },
      version = "^1.0.0",
    },
    "frazrepo/vim-rainbow",
    "windwp/windline.nvim",
    "kyazdani42/nvim-web-devicons",
    "makerj/vim-pdf",
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
    --{ "jghauser/fold-cycle.nvim", config = function() require("fold-cycle").setup() end },
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
    "rafaqz/ranger.vim",
    "tpope/vim-dispatch",
    "bluz71/vim-moonfly-colors"
  }
)
