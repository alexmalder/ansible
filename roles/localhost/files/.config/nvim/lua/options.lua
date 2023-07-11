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

vim.cmd[[autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]
--vim.cmd[[map gf :e <cfile><CR>]]
vim.cmd[[let g:nnn#action = {'<c-t>': 'tab split'}]]
vim.cmd("let g:polyglot_disabled = ['markdown', 'yaml']")
vim.o.updatetime = 250

-- Show line diagnostics automatically in hover window
vim.cmd[[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- autopairs
require'nvim-autopairs'.setup{}

-- lsp signature
cfg = { toggle_key = '<M-r>' }
require'lsp_signature'.setup{cfg}

-- statusline
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

local git_branch = {
    text = git_comps.git_branch(),
    hl_colors = {'white','black'},
    width = 100,
}

-- floaterm
vim.cmd[[let g:floaterm_keymap_toggle = '<C-t>']]
vim.cmd[[let g:floaterm_position = 'right']]
vim.cmd[[let g:floaterm_height = 1.0]]
vim.cmd[[let g:floaterm_width = 0.66]]
require("flutter-tools").setup {}

-- git
require('gitsigns').setup{}

local au = vim.api.nvim_create_autocmd

require("transparent").setup({
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLineNr', 'EndOfBuffer',
  },
  extra_groups = {}, -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})


vim.cmd('let g:rainbow_active = 1')

require'telescope'.load_extension'zoxide'
au({'DirChanged'}, {pattern={'window','tab','tabpage','global'}, callback=function()
    vim.cmd("silent !zoxide add " .. vim.fn.getcwd())
end,group=main})
local status, telescope = pcall(require, 'telescope')
if (not status) then return end
local sorters = require'telescope.sorters'
local previewers = require'telescope.previewers'
local builtin = require'telescope.builtin'
local actions = require'telescope.actions'
telescope.setup{
    defaults={
    extensions={
        fzy_native={
            override_generic_sorter=true,
            override_file_sorter=true,
        },
        zoxide={
            mappings={
                ["<Enter>"]={action=function(selection) builtin.find_files{cwd=selection.path} end},
                ["<Tab>"]={action=function(selection) builtin.find_files{cwd=selection.path} end},
                ["<C-j>"]=actions.cycle_history_next,
				["<C-k>"]=actions.cycle_history_prev,
				["<Esc>"]=actions.close,
                ["<C-Enter>"]={
                    action=function(_) end
                },
            },
        },
    },
    }
}
