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
    -- COMPLETION
    use { 'L3MON4D3/LuaSnip' }
    use { 'hrsh7th/nvim-cmp' }
    use { 'saadparwaiz1/cmp_luasnip' }
    -- LSP
    use 'vim-autoformat/vim-autoformat'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'ray-x/lsp_signature.nvim'
    use 'williamboman/nvim-lsp-installer'
    use 'mcchrish/nnn.vim'
    -- UI/UX
    use 'windwp/windline.nvim'
    use 'kyazdani42/nvim-web-devicons'
    --use 'luochen1990/rainbow'
    use 'sbdchd/neoformat'
    use 'windwp/nvim-autopairs'
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use 'bfrg/vim-cpp-modern'
    use 'makerj/vim-pdf'
    use 'saltstack/salt-vim'
    use 'sjbach/lusty'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'voldikss/vim-floaterm'
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use 'romgrk/barbar.nvim'
    use 'sindrets/diffview.nvim'
    use 'dstein64/vim-startuptime'
    use 'TimUntersberger/neogit'
    use {'neg-serg/neg.nvim'}
end)
