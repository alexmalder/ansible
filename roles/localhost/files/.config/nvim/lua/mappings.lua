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
map('n', '<space>v', ':YAMLView<CR>', opts)
map('n', '<space>l', ':vertical resize -15<CR>', opts)
map('n', '<space>h', ':vertical resize +15<CR>', opts)
map('n', '<space>j', ':resize -15<CR>', opts)
map('n', '<space>k', ':resize +15<CR>', opts)
map('n', '<space>n', ':NnnPicker %:p:h<CR>', opts)
--map('n', '<space>s', ':Lspsaga hover_doc<CR>', opts)
map('n', '<space>b', ':Buffers<CR>', opts)
map('n', 'gd', '<Cmd>lua require"telescope.builtin".lsp_definitions()<CR>', opts)

-- zoxide
map('n', 'cd', '* <Cmd>lua require"telescope".extensions.zoxide.list(require"telescope.themes".get_ivy({layout_config={height=8},border=false}))<CR>', opts)

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
