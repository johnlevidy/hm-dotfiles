local vim = vim

-- Disable HL search with CN
vim.api.nvim_set_keymap('n', '<C-n>', ':nohlsearch<CR>', {noremap = true})

-- Single chord movements between splits
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true})

-- Control + s always saves
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>', {noremap = true})

-- Escape exits terminal mode
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {noremap = true})

-- Next / prev tabs with normal mode
vim.api.nvim_set_keymap('n', '<S-h>', ':tabprev<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<S-l>', ':tabnext<CR>', {noremap = true})

local function is_quickfix_open()
	local windows = vim.api.nvim_list_wins()
	for _, win in ipairs(windows) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_get_option(buf, 'buftype') == 'quickfix' then
			return true
		end
	end
	return false
end
