-- File tree config
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local function toggle_tree()
    require('nvim-tree.api').tree.toggle()
end
-- empty setup using defaults
require('nvim-tree').setup {}

vim.keymap.set('n', '<C-t>t', toggle_tree, {silent = true, noremap = true})
