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

M.b_like_complete = function(list_generator)
	return function(arg_lead, cmd_line, cursor_pos)
		-- Get everything after the command name up to the cursor
		local before_cursor = cmd_line:sub(1, cursor_pos)
		local after_cmd = before_cursor:match('^%S+%s*(.*)$') or ''

		local completions = {}

		-- Find all patterns that match what's been typed so far
		for _, pattern in ipairs(list_generator()) do
			-- Skip if already exactly matches the pattern
			if after_cmd == pattern then
			-- Don't offer completion for exact matches
			-- First try exact prefix match (highest priority)
			elseif
				#after_cmd < #pattern and pattern:sub(1, #after_cmd) == after_cmd
			then
				local remaining = pattern:sub(#after_cmd + 1)
				remaining = remaining:match('^%s*(.*)$') or ''
				local completion = arg_lead .. remaining
				if completion ~= '' then table.insert(completions, completion) end
			-- Then try fuzzy match: check if pattern contains after_cmd as substring
			elseif pattern:find(after_cmd, 1, true) then
				-- For fuzzy matches, return the full pattern
				table.insert(completions, pattern)
			end
		end

		-- Remove duplicates
		local unique_completions = {}
		local seen = {}
		for _, comp in ipairs(completions) do
			if not seen[comp] then
				seen[comp] = true
				table.insert(unique_completions, comp)
			end
		end

		return unique_completions
	end
end

return M
