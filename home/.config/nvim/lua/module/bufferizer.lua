--- Bufferizer
--
-- Provides the :Bufferize command, which takes a regular vim command
-- and redirects it'so output to a scratch buffer.
-- Provides the useful :Messages command

local count = 0

local function bufferize(tbl)
	count = count + 1
	local cmd = table.concat(tbl.fargs, ' ')
	local result = tostring(vim.fn.execute(cmd))
	local text = vim.split(vim.trim(result), '\n')
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(bufnr, 'bufferize:///' .. tostring(count) .. cmd)
	vim.cmd('vsplit')
	local winid = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(winid, bufnr)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, text)
end

local function messages() bufferize({ fargs = { 'messages' } }) end

vim.api.nvim_create_user_command('Bufferize', bufferize, { nargs = '+' })
vim.api.nvim_create_user_command('B', bufferize, { nargs = '+' })

-- TODO: remove once vim._core.ui2 is enabled
vim.api.nvim_create_user_command('Messages', messages, { nargs = 0 })

vim.api.nvim_create_user_command('Bclean', function()
	local curbuf = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local modified = vim.api.nvim_get_option_value('modified', { buf = buf })
		if not modified and curbuf ~= buf then
			vim.api.nvim_buf_delete(buf, { force = false, unload = false })
		end
	end
end, { nargs = 0 })
