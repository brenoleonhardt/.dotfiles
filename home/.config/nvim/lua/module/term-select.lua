local M = {}

-- TODO:
-- 1. this is not an term-select specific plugin: rename it to term-select or something
-- 2. add a nicer function for overriding vim.ui.select
-- 3. add examples for each of my use-cases
-- 4. add a nicer user command

local group = vim.api.nvim_create_augroup('term-select', { clear = true })

M.run = function(opts)
	assert(opts, 'opts is required')
	assert(opts.cmd, 'cmd is required')
	assert(opts.on_result, 'on_result is required')
	opts.cwd = opts.cwd or vim.fn.getcwd()
	opts.rows = opts.rows or 10

	local tmp = vim.fn.tempname()

	local cmd = string.format(
		'botright split | resize %d | enew | chdir %s | term %s > %s',
		opts.rows,
		opts.cwd,
		opts.cmd,
		tmp
	)

	vim.cmd(cmd)

	local bufnr = vim.fn.bufnr()
	local mode = nil

	local cleanup = function()
		vim.fn.delete(tmp)
		vim.api.nvim_buf_delete(bufnr, { force = true })
	end

	local process = function()
		vim.cmd('stopinsert') -- trigger cleanup by TermLeave

		if not mode then return end
		if not vim.fn.filereadable(tmp) then return end

		local results = vim.fn.readfile(tmp)
		if not results or #results == 0 then return end

		opts.on_result(results, mode)
	end

	vim.api.nvim_create_autocmd({ 'TermLeave' }, {
		buffer = bufnr,
		group = group,
		callback = cleanup,
	})

	vim.api.nvim_create_autocmd({ 'TermClose' }, {
		buffer = bufnr,
		group = group,
		callback = process,
	})

	local mappings = {
		['<C-s>'] = 'split',
		['<C-v>'] = 'vsplit',
		['<C-t>'] = 'tabedit',
		['<C-q>'] = 'quickfix',
		['<C-x>'] = 'kill',
		['<CR>'] = 'edit',
	}

	for k, m in pairs(mappings) do
		vim.keymap.set('t', k, function()
			mode = m
			vim.api.nvim_feedkeys(
				vim.api.nvim_replace_termcodes('<CR>', true, false, true),
				'n',
				false
			)
		end, { buffer = bufnr })
	end

	vim.cmd('startinsert')
end

vim.api.nvim_create_user_command('TermSelectSimple', function()
	M.run({
		cmd = 'ls | fzf --multi --preview "cat {}"',
		cwd = '/tmp',
		on_result = function(results, mode)
			print('Selected:', table.concat(results, ', '), 'Mode:', mode)
		end,
	})
end, {})

vim.api.nvim_create_user_command('TermSelectLiveGrep', function()
	M.run({
		cmd = 'fzf --phony --bind "change:reload:rg --line-number --no-heading {q} || true"',
		on_result = function(results, mode)
			print('Selected:', table.concat(results, ', '), 'Mode:', mode)
		end,
	})
end, {})

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice) end

return M
