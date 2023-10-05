
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
  { 'hrsh7th/nvim-cmp' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip' },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'bluz71/vim-moonfly-colors' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'kkharji/lspsaga.nvim' },
  { 'mfussenegger/nvim-jdtls' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
	{
	  "cuducos/yaml.nvim",
	  ft = { "yaml" }, -- optional
	},
  'williamboman/nvim-lsp-installer',
  'junegunn/fzf',
  'junegunn/fzf.vim',
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  "nvim-telescope/telescope.nvim",
  'windwp/nvim-autopairs',
  'frazrepo/vim-rainbow',
  'mcchrish/nnn.vim',
  'Mofiqul/vscode.nvim',
  'neg-serg/neg.nvim',
  'windwp/windline.nvim',
  'kyazdani42/nvim-web-devicons',
  'akinsho/bufferline.nvim',
  'makerj/vim-pdf',
  'bfrg/vim-cpp-modern',
  'vim-autoformat/vim-autoformat',
  'sbdchd/neoformat',
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  'sindrets/diffview.nvim',
  'NeogitOrg/neogit',
  'sharksforarms/neovim-rust',
  'ajeetdsouza/zoxide',
  'jvgrootveld/telescope-zoxide',
  {
    'akinsho/flutter-tools.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim'
    },
  },
  'xiyaowong/nvim-transparent',
  }
)
