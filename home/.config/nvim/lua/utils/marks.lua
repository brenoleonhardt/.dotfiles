local M = {}

M.list = function()
	local buffer_marks = vim
		.iter(vim.fn.getmarklist(vim.fn.bufnr()))
		:map(function(mark)
			mark.file = vim.fn.bufname()
			return mark
		end)
		:totable()

	local global_marks = vim.fn.getmarklist()

	local all_marks = vim.list_extend(buffer_marks, global_marks)

	-- TODO:
	-- marks 1-9 are automatically set, based on the last exit position
	-- - they are shifted whenever opening up vim
	-- - they shouldn't be used as static global marks
	-- - A-Z are global marks
	-- - we can "wrap" m1-9  and `1-9
	local marks = vim
		.iter(all_marks)
		:filter(function(item) return item.mark:match("^'['A-Z]$") end)
		:totable()

	return marks
end

return M
