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
  "williamboman/nvim-lsp-installer",
  "junegunn/fzf",
  "junegunn/fzf.vim",
  {
    'nvim-treesitter/nvim-treesitter',
    version = 'v0.10.0',
    lazy = false,
    build = ':TSUpdate'
  },
  "nvim-telescope/telescope.nvim",
  "windwp/nvim-autopairs",
  "kyazdani42/nvim-web-devicons",
  "sbdchd/neoformat",
  { "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  "sindrets/diffview.nvim",
  "sharksforarms/neovim-rust",
  {
    "https://tangled.org/cuducos.me/yaml.nvim",
    ft = { "yaml" }, -- optional
    dependencies = {
      "folke/snacks.nvim", -- optional
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua" -- optional
    },
  },
  "ajeetdsouza/zoxide",
  "jvgrootveld/telescope-zoxide",
  {
      'tribela/transparent.nvim',
      event = 'VimEnter',
      config = true,
  },
  "hashivim/vim-terraform",
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
      dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    "lewis6991/hover.nvim",
  },
  {
    "mcchrish/nnn.vim"
  },
  {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
      ---@module 'render-markdown'
      ---@type render.md.UserConfig
      opts = {},
  },
  {
    'makerj/vim-pdf'
  },
  {
    "aktersnurra/no-clown-fiesta.nvim",
	  theme = "dark", -- supported themes are: dark, dim, light
	  transparent = false, -- Enable this to disable the bg color
	  styles = {
	    -- You can set any of the style values specified for `:h nvim_set_hl`
	    comments = {},
	    functions = {},
	    keywords = {},
	    lsp = {},
	    match_paren = {},
	    type = {},
	    variables = {},
	  },
    config = function()
        vim.cmd("colorscheme no-clown-fiesta")
    end,
  },
  {
    "hedyhli/outline.nvim",
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { 
	desc = "Toggle Outline" 
      })

      require("outline").setup {
        -- Your setup opts here (leave empty to use defaults)
      }
    end,
  },

})

