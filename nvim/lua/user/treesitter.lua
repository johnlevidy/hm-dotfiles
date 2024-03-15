require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}
-- vim.cmd 'set foldmethod=expr'
-- vim.cmd 'set foldexpr=nvim_treesitter#foldexpr()'
