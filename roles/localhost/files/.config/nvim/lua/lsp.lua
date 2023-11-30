-- LSP
local lsp = require("lspconfig")
vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    ultisnips = false;
    luasnip = true;
  };
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

--local luasnip = require("luasnip")
--local cmp = require("cmp")
--local ELLIPSIS_CHAR = '…'
--local MAX_LABEL_WIDTH = 20
--local MIN_LABEL_WIDTH = 20
--cmp.setup({
--    snippet = {
--      expand = function(args)
--        luasnip.lsp_expand(args.body) -- For `luasnip` users.
--      end,
--    },
--    mapping = cmp.mapping.preset.insert({
--        ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
--        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--        ['<C-f>'] = cmp.mapping.scroll_docs(4),
--        ['<C-Space>'] = cmp.mapping.complete(),
--        ['<C-e>'] = cmp.mapping.abort(),
--        ['<CR>'] = cmp.mapping.confirm({ select = true }),
--    }),
--    sources = cmp.config.sources({
--        { name = 'nvim_lsp' },
--        { name = 'path' },
--        { name = 'buffer' },
--        { name = 'nvim_lsp_signature_help' }
--    }),
--    formatting = {
--      format = function(entry, vim_item)
--        local label = vim_item.abbr
--        local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
--        if truncated_label ~= label then
--          vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
--        elseif string.len(label) < MIN_LABEL_WIDTH then
--          local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
--          vim_item.abbr = label .. padding
--        end
--        return vim_item
--      end,
--    },
--})
--cmp.setup.cmdline('/', {
--    sources = {
--        { name = 'path' }
--    }
--})
--local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
lsp.clangd.setup{
    cmd = { "/usr/bin/clangd" },
    filetypes = { "c", "cpp", "objc" },
    capabilities = capabilities
}
lsp.jdtls.setup{}
--lsp.yamlls.setup { capabilities = capabilities }
--lsp.ansiblels.setup { cmd = { "ansible-language-server", "--stdio" }, filetypes = { "yaml.ansible" }, }
