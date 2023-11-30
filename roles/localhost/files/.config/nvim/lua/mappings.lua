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
map('n', '<space>s', ':Lspsaga hover_doc<CR>', opts)
map('n', '<space>b', ':Buffers<CR>', opts)
map('n', 'gd', '<Cmd>lua require"telescope.builtin".lsp_definitions()<CR>', opts)

-- zoxide
map('n', 'cd', '* <Cmd>lua require"telescope".extensions.zoxide.list(require"telescope.themes".get_ivy({layout_config={height=8},border=false}))<CR>', opts)

-- asyncterm
map('n', '<C-t>', ':AsyncRun -mode=term -pos=bottom -rows=10 fish<CR>', opts)

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- autocompletion

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif require('luasnip').expand_or_jumpable() then
    return vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true)
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif require('luasnip').expand_or_jumpable() then
    return vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true)
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm({ 'keys': '<CR>', 'select': v:true })", { expr = true })


