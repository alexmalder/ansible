local au = vim.api.nvim_create_autocmd
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
