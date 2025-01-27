local hostname = io.popen("uname -n"):read("*l")

if not string.find(hostname, "fssc") then 
  require("obsidian").setup({
    workspaces = {
      {
        name = "notes",
	path = "~/notes/notes",
      },
    },
    note_id_func = function(title)
      return title
    end,
    note_frontmatter_func = function(note)
      return { tags = note.tags }
    end,
  })
end

vim.api.nvim_set_keymap('n', '<C-o>t', ':ObsidianToday<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-o>T', ':ObsidianToday ', { noremap = true, silent = false})
