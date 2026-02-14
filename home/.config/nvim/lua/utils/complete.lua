local M = {}

-- ls -la | gr<Tab>                      " completes shell commands (grep, etc.)
-- ls -la | grep foo<Tab>                " completes filenames
-- cat file.txt | sort | uniq | wc<Tab>  " completes shell commands after last |
M.better_shellcmdline = function(arg_lead, cmd_line, cursor_pos)
	local args = vim.split(cmd_line, '%s+', { trimempty = true })
	table.remove(args, 1)
	local line_to_cursor = cmd_line:sub(1, cursor_pos)
	local args_part = line_to_cursor:match('^%S+%s+(.*)') or ''
	local last_pipe_pos = args_part:match('.*()%|') or 0
	local after_pipe = args_part:sub(last_pipe_pos + 1)
	local words_after_pipe = vim.split(after_pipe, '%s+', { trimempty = true })
	if
		#words_after_pipe == 0
		or (#words_after_pipe == 1 and not after_pipe:match('%s$'))
	then
		return vim.fn.getcompletion(arg_lead, 'shellcmd')
	else
		return vim.fn.getcompletion(arg_lead, 'file')
	end
end

return M
