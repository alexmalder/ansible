-- LSP
local lsp = require("lspconfig")
local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'nvim_lsp_signature_help' }
    })
})

cmp.setup.cmdline('/', {
    sources = {
        { name = 'path' }
    }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
lsp.pyright.setup {
    capabilities = capabilities
}
--lsp.yamlls.setup { capabilities = capabilities }
--lsp.lua_ls.setup { cmd = {"/opt/local/bin/lua-language-server"}, capabilities = capabilities }
--lsp.ansiblels.setup { cmd = { "ansible-language-server", "--stdio" }, filetypes = { "yaml.ansible" }, }
lsp.rust_analyzer.setup{
    capabilities = capabilities
}
lsp.clangd.setup{
    cmd = { "/usr/bin/clangd" },
    filetypes = { "c", "cpp", "objc" },
    capabilities = capabilities
}
lsp.jdtls.setup{}
