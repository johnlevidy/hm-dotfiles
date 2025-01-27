-- File tree config
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local function toggle_tree()
    require('nvim-tree.api').tree.toggle()
end
require('nvim-tree').setup {
  update_focused_file = {
    enable = true,
  },
  view = {
    width = {
      min = 30,
      max = 80,
      padding = 1,
    }
  }
}

vim.keymap.set('n', '<C-t>t', toggle_tree, {silent = true, noremap = true})
