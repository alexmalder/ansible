vim.opt.scrollback = 0
vim.opt.tabstop=2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.conceallevel = 1
vim.opt.concealcursor = 'niv'
vim.opt.path = vim.opt.path + ',.,..,/usr/include,./include,../include,*'
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.hlsearch = true
vim.opt.guicursor = ""
vim.opt.backupdir = '/tmp'
vim.opt.directory = '/tmp'
vim.opt.undodir = '/tmp'
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.signcolumn = "yes"
vim.opt.number = true

vim.diagnostic.config({ virtual_text = false })

--vim.cmd[[autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]
--vim.cmd[[map gf :e <cfile><CR>]]
vim.o.updatetime = 250

-- Show line diagnostics automatically in hover window
vim.cmd[[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- autopairs
require'nvim-autopairs'.setup{}

-- git
require('gitsigns').setup{}
vim.cmd[[set guicursor=v-c-sm:block,n-i-ci-ve:ver25,r-cr-o:ver25]]

vim.opt.termguicolors = true

-- local neogit = require('neogit')
-- neogit.setup {}
