local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup {
	pickers = {
		oldfiles = {theme = 'dropdown', previewer = false},
		find_files = {
			theme = 'dropdown',
			previewer = false,
		},
		lsp_workspace_symbols = {theme = 'dropdown', previewer = false},
		grep_string = {theme = 'dropdown', previewer = true},
		live_grep = {theme = 'dropdown', previewer = true},
		lsp_definitions = {theme = 'dropdown', previewer = true},
		lsp_references = {theme = 'dropdown', previewer = true},
		lsp_incoming_calls = {theme = 'dropdown', previewer = true},
	},
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = 'smart_case'
		}
	}
}
telescope.load_extension('fzf')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-p>', builtin.find_files, {noremap = true})
vim.keymap.set('n', '<C-f>s', builtin.lsp_workspace_symbols, {noremap = true})
vim.keymap.set('n', '<C-f>*', builtin.grep_string, {noremap = true})
vim.keymap.set('n', '<C-f>g', builtin.live_grep, {noremap = true})
-- Sort of strictly worse than finding definitions afaict, since those work for typedefs
-- vim.keymap.set('n', '<C-f>t', builtin.lsp_type_definitions, {noremap = true})
vim.keymap.set('n', '<C-f>d', builtin.lsp_definitions, {noremap = true})
vim.keymap.set('n', '<C-f>r', builtin.lsp_references, {noremap = true})
vim.keymap.set('n', '<C-f>i', builtin.lsp_incoming_calls, {noremap = true})
vim.keymap.set('n', '<C-f>q', builtin.quickfix, {noremap = true})
