local M = function()
	local roots = {
		'~/git',
		'~/sketch',
		'~/tmp',
	}

	local ignore = { '.asdf' }

	local cmd = { 'fd', '-H', '-I', '-t', 'd', '^.git$', '-d', '2' }

	local inserts = {
		'~/.dotfiles',
		'~/.password-store',
		'~/bin',
		'~/notes',
	}

	for _, pat in ipairs(ignore) do
		table.insert(cmd, '-E')
		table.insert(cmd, pat)
	end

	for _, root in ipairs(roots) do
		table.insert(cmd, vim.fn.expand(root))
	end

	local out = vim.system(cmd, { text = true }):wait()
	assert(out.code == 0, out.stderr)
	assert(out.stdout ~= '', 'No projects found.')

	local map_path = function(line)
		local path = string.gsub(line, '/.git/', '')
		local dir = vim.fn.fnamemodify(string.gsub(path, vim.env.HOME, '~'), ':h')
		local name = vim.fn.fnamemodify(path, ':t')
		return { path = path, dir = dir, name = name }
	end

	local projects =
		vim.iter(vim.split(vim.trim(out.stdout), '\n')):map(map_path):totable()

	for _, insert in ipairs(inserts) do
		table.insert(projects, 1, map_path(vim.fn.expand(insert)))
	end

	vim.ui.select(projects, {
		prompt = 'Switch to project',
		format_item = function(project, cols)
			local padding = cols - string.len(project.name) - 9
			local pat = '  %s %' .. tostring(padding) .. 's'
			return string.format(pat, project.name, '[' .. project.dir .. ']')
		end,
	}, function(choice, _, mode)
		if mode == 'tab' then vim.cmd('tabnew') end
		if mode == 'vsplit' then vim.cmd('vsplit') end
		if mode == 'split' then vim.cmd('split') end
		require('oil').open(choice.path)
	end)
end

return M
