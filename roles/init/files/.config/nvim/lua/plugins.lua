local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
local execute = vim.api.nvim_command
vim.o.termguicolors = true
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute('packadd packer.nvim')
end
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- INITIALIZE
    use 'wbthomason/packer.nvim'
    -- LSP
    use { 'hrsh7th/nvim-cmp' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use { 'L3MON4D3/LuaSnip' }
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'ray-x/lsp_signature.nvim'
    use 'williamboman/nvim-lsp-installer'
    use 'glepnir/lspsaga.nvim'
    -- SEARCH ENGINE
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    -- COMPLETION
    use 'windwp/nvim-autopairs'
    -- UI/UX
    use 'mcchrish/nnn.vim'
    use 'neg-serg/neg.nvim'
    use 'romgrk/barbar.nvim'
    use 'windwp/windline.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'voldikss/vim-floaterm'
    -- SYNTAX
    use 'makerj/vim-pdf'
    use 'bfrg/vim-cpp-modern'
    -- FORMATTERS
    use 'vim-autoformat/vim-autoformat'
    use 'sbdchd/neoformat'
    -- GIT
    use 'TimUntersberger/neogit'
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use 'sindrets/diffview.nvim'
end)
