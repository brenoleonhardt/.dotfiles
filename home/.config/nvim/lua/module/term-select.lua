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

	local cwd = opts.cwd or vim.fn.getcwd()
	local rows = opts.rows or 10
	local tmp = vim.fn.tempname()
	local cmd = 'botright term cd ' .. cwd .. ' && ' .. opts.cmd .. ' > ' .. tmp
	local mode = nil

	vim.cmd(cmd)
	vim.cmd('resize ' .. rows)

	local bufnr = vim.fn.bufnr()

	local cleanup = function()
		if opts.cleanup == false then return end
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
		cleanup = false, -- optional, default to true
		rows = 20,
		on_result = function(results, mode)
			print('Selected:', table.concat(results, ', '), 'Mode:', mode)
		end,
	})
end, {})

vim.api.nvim_create_user_command('TermSelectLiveGrep', function()
	M.run({
		cmd = 'fzf --phony --bind "change:reload:rg --line-number --no-heading {q} || true"',
		cleanup = false, -- optional, default to true
		rows = 20,
		on_result = function(results, mode)
			print('Selected:', table.concat(results, ', '), 'Mode:', mode)
		end,
	})
end, {})


---@diagnostic disable-next-line: duplicate-set-field
-- vim.ui.select = function (items, opts, on_choice)
local select = function (items, opts, on_choice)
	local prompt = opts and opts.prompt or 'Select:'
	local format_item = opts.format_item or function(item) return item end

	-- for now, let's consider we'll always feed a list of items
	

	-- we need to feed fzf:
	-- 1;format_item(item)
	

	local tmp = vim.fn.tempname()
	for _, item in ipairs(items) do 
		-- append to tmp file
		
	end
	

	M.run({
		cmd = [[fzf --with-nth=2.. --delimiter=$';']]
	})
	
end



-- vim.ui.select({items}, {opts}, {on_choice})                  *vim.ui.select()*
--     Prompts the user to pick from a list of items, allowing arbitrary
--     (potentially asynchronous) work until `on_choice`.

--     Example: >lua
--         vim.ui.select({ 'tabs', 'spaces' }, {
--             prompt = 'Select tabs or spaces:',
--             format_item = function(item)
--                 return "I'd like to choose " .. item
--             end,
--         }, function(choice)
--             if choice == 'spaces' then
--                 vim.o.expandtab = true
--             else
--                 vim.o.expandtab = false
--             end
--         end)
-- <

--     Parameters: ~
--       • {items}      (`any[]`) Arbitrary items
--       • {opts}       (`table`) Additional options
--                      • prompt (string|nil) Text of the prompt. Defaults to
--                        `Select one of:`
--                      • format_item (function item -> text) Function to format
--                        an individual item from `items`. Defaults to
--                        `tostring`.
--                      • kind (string|nil) Arbitrary hint string indicating the
--                        item shape. Plugins reimplementing `vim.ui.select` may
--                        wish to use this to infer the structure or semantics of
--                        `items`, or the context in which select() was called.
--       • {on_choice}  (`fun(item: T?, idx: integer?)`) Called once the user
--                      made a choice. `idx` is the 1-based index of `item`
--                      within `items`. `nil` if the user aborted the dialog.

return M
