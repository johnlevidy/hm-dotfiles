require('symbols-outline').setup()

vim.keymap.set('n', '<C-t>s', function() vim.cmd('SymbolsOutline') end, {silent = true, noremap = true})
