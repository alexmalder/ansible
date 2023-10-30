local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


-- visual
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- fm
map('n', 'f', ':Telescope find_files<CR>', opts)
map('n', 'r', ':Telescope live_grep<CR>', opts)

-- spaces
map('n', '<space>y', ':YAMLTelescope<CR>', opts)
map('n', '<space>l', ':vertical resize -15<CR>', opts)
map('n', '<space>h', ':vertical resize +15<CR>', opts)
map('n', '<space>j', ':resize -15<CR>', opts)
map('n', '<space>k', ':resize +15<CR>', opts)
map('n', '<space>n', ':NnnPicker %:p:h<CR>', opts)
map('n', '<space>s', ':Lspsaga hover_doc<CR>', opts)
map('n', '<space>b', ':Buffers<CR>', opts)
map('n', 'gd', '<Cmd>lua require"telescope.builtin".lsp_definitions()<CR>', opts)

-- zoxide
map('n', 'cd', '* <Cmd>lua require"telescope".extensions.zoxide.list(require"telescope.themes".get_ivy({layout_config={height=8},border=false}))<CR>', opts)

-- folding
vim.keymap.set('n', '<tab>', function() return require('fold-cycle').open() end, {silent = true, desc = 'Fold-cycle: open folds'})
vim.keymap.set('n', '<s-tab>', function() return require('fold-cycle').close() end, {silent = true, desc = 'Fold-cycle: close folds'})
vim.keymap.set('n', 'zC', function() return require('fold-cycle').close_all() end, {remap = true, silent = true, desc = 'Fold-cycle: close all folds'})
