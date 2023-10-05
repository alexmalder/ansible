local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


-- visual
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- fm
map('n', 'f', ':FZF<CR>', opts)
map('n', 'r', ':Rg<CR>', opts)

-- spaces
map('n', '<space>l', ':vertical resize -15<CR>', opts)
map('n', '<space>h', ':vertical resize +15<CR>', opts)
map('n', '<space>j', ':resize -15<CR>', opts)
map('n', '<space>k', ':resize +15<CR>', opts)
map('n', '<space>n', ':NnnPicker %:p:h<CR>', opts)
--map('n', '<space>s', ':Lspsaga hover_doc<CR>', opts)
map('n', '<space>b', ':Buffers<CR>', opts)
map('n', 'gd', '<Cmd>lua require"telescope.builtin".lsp_definitions()<CR>', opts)

-- alt and control
map('n', '<C-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<C-.>', '<Cmd>BufferNext<CR>', opts)
map('n', '<C-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<C->>', '<Cmd>BufferMoveNext<CR>', opts)
map('n', '<C-p>', '<Cmd>BufferPin<CR>', opts)
map('n', '<C-c>', '<Cmd>BufferClose<CR>', opts)

map('n', 'cd', '* <Cmd>lua require"telescope".extensions.zoxide.list(require"telescope.themes".get_ivy({layout_config={height=8},border=false}))<CR>', opts)
