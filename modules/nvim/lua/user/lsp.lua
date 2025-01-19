-- All autocomplete
local cmp = require('cmp')
local lspkind = require('lspkind')
vim.lsp.set_log_level('debug')

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
	expand = function(args)
	    vim.fn["vsnip#anonymous"](args.body)
	end,
    },
    window = {
	    completion = cmp.config.window.bordered(),
	    documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
	    ['<C-Space>'] = cmp.mapping.complete(),
	    ['<CR>'] = cmp.mapping.confirm({select = true}),
	    ['<Tab>'] = cmp.mapping(function(fallback)
	        if vim.fn["vsnip#jumpable"](1) == 1 then
	    	feedkey("<Plug>(vsnip-jump-next)", "")
	        elseif has_words_before() then
	    	cmp.complete()
	        else
	    	fallback()
	        end
	    end, {"i", "s"}),
        ['<S-Tab>'] = cmp.mapping(function()
            if vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
	    end, {"i", "s"}),
    }),
    formatting = {
        format = lspkind.cmp_format({
	    mode = 'symbol_text',
	    maxwidth = 50,
	    ellipsis_char = '..',
	})},
    sources = cmp.config.sources({
	{ name = 'nvim_lsp' },
	{ name = 'vsnip' },
    }, {
	{ name = 'buffer' },
    })
})

cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['clangd'].setup {
    cmd = {
    "clangd",
    "--background-index",
    },
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = false,
        underline = false,
        virtual_text = false,
    }),
    }
}
require('lspconfig')['lua_ls'].setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = {'vim'}
            }
        }
    },
    on_attach = on_attach,
    capabilities = capabilities,
}
