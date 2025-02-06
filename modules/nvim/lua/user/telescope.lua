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
		lsp_implementations = {theme = 'dropdown', previewer = true},
		lsp_references = {theme = 'dropdown', previewer = true},
		lsp_incoming_calls = {theme = 'dropdown', previewer = true},
	},
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default + actions.center,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = 'smart_case'
		},
		["ui-select"] = {
		  require("telescope.themes").get_dropdown {}
		}
	}
}

telescope.load_extension('ui-select')
telescope.load_extension('fzf')

local function execute_with_mark(func)
  return function()
    vim.cmd("normal! mR")
    func()
  end
end

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-p>',  execute_with_mark(builtin.find_files), {noremap = true})
vim.keymap.set('n', '<C-f>*', execute_with_mark(builtin.grep_string), {noremap = true})
vim.keymap.set('n', '<C-f>g', execute_with_mark(builtin.live_grep), {noremap = true})
vim.keymap.set('n', '<C-f>d', execute_with_mark(builtin.lsp_definitions), {noremap = true})
vim.keymap.set('n', '<C-f>r', execute_with_mark(builtin.lsp_references), {noremap = true})
vim.keymap.set('n', '<C-f>i', execute_with_mark(builtin.lsp_incoming_calls), {noremap = true})
vim.keymap.set('n', '<C-f>q', execute_with_mark(builtin.quickfix), {noremap = true})
vim.keymap.set('n', '<C-f>m', execute_with_mark(builtin.lsp_implementations), {noremap = true})
-- vim.keymap.set('n', '<C-f>s', builtin.lsp_workspace_symbols, {noremap = true})
-- Sort of strictly worse than finding definitions afaict, since those work for typedefs
-- vim.keymap.set('n', '<C-f>t', builtin.lsp_type_definitions, {noremap = true})
