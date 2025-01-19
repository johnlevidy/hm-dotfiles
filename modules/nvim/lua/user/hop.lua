local hop = require('hop')

local readwise_distance = function(a, b, _)
	return (100 * math.abs(b.row - a.row)) + (b.col - a.col);
end

hop.setup{keys = 'asdfjklqweruiopzxmtgbyhn', x_bias = 10,
          distance_method = readwise_distance }

local directions = require('hop.hint').HintDirection
vim.keymap.set({'o', 'n'}, 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false, jump_on_sole_occurrence = false})
end, {remap = true})
vim.keymap.set({'o', 'n'}, 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, jump_on_sole_occurrence = false})
end, {remap = true})
vim.keymap.set({'o', 'n'}, 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false,  hint_offset = -1, jump_on_sole_occurrence = false})
end, {remap = true})
vim.keymap.set({'o', 'n'}, 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = -1, jump_on_sole_occurrence = false})
end, {remap = true})
