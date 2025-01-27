-- All autocomplete
local cmp = require('cmp')
local lspkind = require('lspkind')
local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local kind_icons = {
      Text = " ",
      Method = "󰆧  ",
      Function = "󰊕",
      Constructor = " ",
      Field = "󰇽 ",
      Variable = "󰂡",
      Class = "󰠱 ",
      Interface = "  ",
      Module = "  ",
      Property = "󰜢 ",
      Unit = " ",
      Value = "󰎠 ",
      Enum = " ",
      Keyword = "󰌋 ",
      Snippet = " ",
      Color = "󰏘 ",
      File = "󰈙 ",
      Reference = " ",
      Folder = "󰉋 ",
      EnumMember = " ",
      Constant = "󰏿",
      Struct = "  ",
      Event = " ",
      Operator = "󰆕 ",
      TypeParameter = "󰅲",
}

vim.diagnostic.config({ update_in_insert = false })

cmp.setup({
    preselect = cmp.PreselectMode.None,
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
        ['<C-e>'] = cmp.mapping.abort(),
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
	    maxwidth = 60,
	    ellipsis_char = '..',
	})},
    sources = cmp.config.sources({
	{ name = 'nvim_lsp' },
	{ name = 'vsnip' },
    { name = 'buffer' },
    })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['clangd'].setup {
  cmp = {
      "clangd",
      "--background-index",
      "--header-insertion=never",
      "--clang-tidy=false",
      "--completion-style=detailed",
  },
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
          signs = false,
          underline = false,
          virtual_text = {
              spacing = 14,
          },
      }
    ),
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
-- Use buffer sources for '/'
local standard_mapping = cmp.mapping.preset.cmdline({
    ['<C-n>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
    ['<C-p>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
})

-- Set mapping for autofix / G for generate code
vim.keymap.set('n', '<C-g>a', vim.lsp.buf.code_action, { noremap = true })
vim.keymap.set('n', '<C-g>r', vim.lsp.buf.rename, { noremap = true })

cmp.setup.cmdline('/', {
    mapping = standard_mapping,
    {sources = {{name = 'buffer'}}}
})

cmp.setup.cmdline(':', {
    mapping = standard_mapping,
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}}),
})

local M = {}
M.pending_requests = {}
local spinner_frames = { '1', '2', '3', '4' }
local current_frame = 1
-- Timer for the psinner
--
local timer = vim.loop.new_timer()
timer:start(0, 100, vim.schedule_wrap(function()
    current_frame = (current_frame % #spinner_frames) + 1
    require('lualine').refresh()
end))

-- Function to update stauts line
function M.update_statusline()
    local spinner = spinner_frames[current_frame]
    local pending_count = 0

    -- Count pending LSP pending_requests
    for _, request in pairs(M.pending_requests) do
        pending_count = pending_count + 1
    end

    if pending_count > 0 then
        return string.format("%s %d LSP Requests Pending", spinner, pending_count)
    else
        return ""
    end
end

vim.api.nvim_create_autocmd('LspRequest', {
  callback = function(args)
    local request_id = args.data.request_id
    local request = args.data.request

    if request.type == 'pending' then
      M.pending_requests[request_id] = request
    elseif request.type == 'cancel' or request.type == 'complete' then
      M.pending_requests[request_id] = nil
    end
  end,
})
return M


