require('gitsigns').setup{}
--vim.cmd[[let g:rainbow_active = 1]]
--vim.cmd[[let g:fzf_layout = { 'down': '40%' }]]
vim.cmd("let g:polyglot_disabled = ['markdown', 'yaml']")
vim.opt.scrollback = 0
vim.opt.tabstop=4
vim.opt.shiftwidth = 4
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
vim.cmd[[autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]
vim.cmd[[map gf :e <cfile><CR>]]
--vim.cmd[[let g:nnn#layout = 'new']]
vim.cmd[[let g:nnn#action = {'<c-t>': 'tab split'}]]
-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd[[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
require'nvim-autopairs'.setup{}
cfg = { toggle_key = '<M-r>' }
require'lsp_signature'.setup{cfg}
require('wlsample.vscode')
local windline = require('windline')
windline.setup({
    colors_name = function(colors)
        colors.StatusFg = colors.ActiveFg
        colors.StatusBg = "#000000"
        return colors
    end,
    statuslines = {
        default,
        explorer,
    },
})
local git_comps = require('windline.components.git')
-- syntax using table
local git_branch = {
    text = git_comps.git_branch(),
    hl_colors = {'white','black'},
    width = 100,
}
-- FLOATERM
vim.cmd[[let g:floaterm_keymap_toggle = '<F12>']]
vim.cmd[[let g:floaterm_position = 'right']]
vim.cmd[[let g:floaterm_height = 1.0]]
vim.cmd[[let g:floaterm_width = 0.66]]
--vim.cmd[[let g:floaterm_width = '1.0']]
local neogit = require('neogit')
neogit.setup {}

