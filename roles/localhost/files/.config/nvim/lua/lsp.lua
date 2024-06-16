-- LSP
local lsp = require("lspconfig")
vim.o.completeopt = "menuone,noselect"

local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },


  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

lsp.bashls.setup {
  capabilities = capabilities
}
lsp.tsserver.setup {
  capabilities = capabilities
}
lsp.gopls.setup {
  capabilities = capabilities
}
lsp.dartls.setup {
  capabilities = capabilities
}
lsp.omnisharp.setup{
  cmd = { "/usr/bin/omnisharp", "--languageserver" , "--hostPID", tostring(pid) },
  capabilities = capabilities
}
lsp.pylsp.setup {
  capabilities = capabilities
}
lsp.terraformls.setup{
  capabilities=capabilities,
  command="/opt/local/bin/terraform-ls"
}
lsp.lua_ls.setup {
  cmd = {"/opt/local/bin/lua-language-server"},
  capabilities = capabilities
}
lsp.rust_analyzer.setup{
  capabilities = capabilities
}
lsp.cmake.setup {
  capabilities = capabilities
}
lsp.clangd.setup{
  cmd = { "/usr/bin/clangd" },
  filetypes = { "c", "cpp", "objc" },
  capabilities = capabilities
}

lsp.sqlls.setup {
  capabilities = capabilities
}

lsp.jdtls.setup{}
--lsp.yamlls.setup { capabilities = capabilities }
--lsp.ansiblels.setup { cmd = { "ansible-language-server", "--stdio" }, filetypes = { "yaml.ansible" }, }
