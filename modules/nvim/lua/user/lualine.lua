local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then return end

lualine.setup {
    options = {
	theme = 'gruvbox',
	icons_enabled = false,
	component_separators = {'', ''},
	disabled_filetypes = {"alpha", "dashboard", "NvimTree", "Outline"},
	always_divide_middle = true,
	globalstatus = true,
	refresh = {
	    statusline = 200,
	    tabline = 200,
	    winbar = 200,
	}
    },
    sections = {
	lualine_b = { 'branch', 'diff' },
	lualine_c = {{'filename', path=1}},
    },
}

vim.cmd([[
hi StatusLineNc gui=None guibg=NonText guisp=NonText
hi StatusLine gui=None guibg=NonText guisp=NonText]])
