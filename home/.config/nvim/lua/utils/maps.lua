---@diagnostic disable: deprecated
local bufutil = require('utils.buf')
local daputil = require('utils.dap')
local greputils = require('utils.grep')
local lsputil = require('utils.lsp')
local qfutil = require('utils.qf')
local rootutil = require('utils.root')

local M = {}

M.errors_buffer = function() qfutil.errors({ workspace = false }) end

M.find_buffers = function() require('telescope.builtin').buffers({}) end
M.find_curdir = function()
	require('telescope.builtin').find_files({
		cwd = vim.fn.getcwd(),
		hidden = true,
	})
end
M.find_rfiles = function()
	local root = rootutil.git_root()
	vim.notify("info: searching '" .. root .. "'", vim.log.levels.INFO)
	require('telescope.builtin').find_files({
		cwd = root,
		hidden = true,
	})
end

M.find_gitstatus = function() require('telescope.builtin').git_status({}) end
M.find_helptag = function() require('telescope.builtin').help_tags({}) end
M.find_config = require('utils.pickers.configs')
M.find_make = require('utils.pickers.make')
M.find_pfiles = function()
	---@type {path: string}[]
	local roots = rootutil.project_roots()
	if #roots == 0 then
		roots = { { path = rootutil.git_root() } }
		vim.notify(
			'error: no project roots found - defaulting to git',
			vim.log.levels.WARN
		)
	end
	if #roots == 0 then
		return vim.notify('error: not a git repository', vim.log.levels.WARN)
	end
	vim.notify("info: searching '" .. roots[1].path .. "'", vim.log.levels.INFO)
	require('telescope.builtin').find_files({
		cwd = roots[1].path,
		hidden = true,
	})
end
M.find_recent = function() require('telescope.builtin').oldfiles({}) end
M.find_grep = function()
	require('telescope.builtin').live_grep({
		cwd = rootutil.git_root(),
		additional_args = { '--hidden' },
	})
end
M.find_star = function()
	require('telescope.builtin').grep_string({
		cwd = rootutil.git_root(),
		additional_args = { '--hidden' },
	})
end

M.find_zk = function() vim.cmd([[ZkNotes { sort = { 'modified' } }]]) end
M.find_mark = require('utils.pickers.marks')
M.find_registers = function() require('telescope.builtin').registers({}) end
M.find_doc_symbol = function()
	require('telescope.builtin').lsp_document_symbols({})
end
M.find_ws_symbol = function()
	require('telescope.builtin').lsp_workspace_symbols({})
end

M.git_blame = function() vim.cmd([[Git blame]]) end
M.git_fugitive = function() bufutil.toggle('fugitive', { cb = vim.cmd.G }) end
M.git_link = function() require('utils.gitlink').gitlink() end
M.git_log = function() vim.cmd([[G log -n 999]]) end
M.git_clog = function()
	local cmd =
		vim.api.nvim_replace_termcodes(':Gclog -n 999 --grep ', true, true, true)
	vim.api.nvim_feedkeys(cmd, 'n', true)
end
M.git_preview = function() require('gitsigns').preview_hunk() end
M.git_reset = function() require('gitsigns').reset_hunk() end
M.git_stage = function() require('gitsigns').stage_hunk() end
M.git_unstage = function() require('gitsigns').undo_stage_hunk() end

M.goto_declaration = function()
	lsputil.wrap(vim.lsp.buf.declaration, { on_list = lsputil.on_list })
end
M.goto_definition = function()
	if vim.o.ft == 'help' then
		M.keywordprg()
	else
		vim.lsp.buf.definition({ on_list = lsputil.on_list })
	end
end
M.goto_implementation = function()
	vim.lsp.buf.implementation({ on_list = lsputil.on_list })
end
M.goto_incoming = function() vim.lsp.buf.incoming_calls() end
M.goto_outgoing = function() vim.lsp.buf.outgoing_calls() end
M.goto_references = function()
	vim.lsp.buf.references(nil, { on_list = lsputil.on_list })
end
M.goto_typedef = function()
	vim.lsp.buf.type_definition({ on_list = lsputil.on_list })
end
M.qf_buf_symbols = function() vim.lsp.buf.document_symbol({ loclist = false }) end

M.jump_argnext = function() return vim.cmd('next') end
M.jump_argprev = function() return vim.cmd('prev') end
M.jump_bufnext = function() vim.cmd('bnext') end
M.jump_bufprev = function() vim.cmd('bprevious') end
M.jump_chunknext = function()
	if vim.o.diff then
		vim.cmd('normal! ]c')
	else
		require('gitsigns').next_hunk()
	end
end
M.jump_chunkprev = function()
	if vim.o.diff then
		vim.cmd('normal! [c')
	else
		require('gitsigns').prev_hunk()
	end
end
M.jump_errornext = function() vim.diagnostic.goto_next() end
M.jump_errorprev = function() vim.diagnostic.goto_prev() end
M.jump_qfnext = function() qfutil.next_entry() end
M.jump_qfprev = function() qfutil.prev_entry() end
M.jump_tabnext = function() vim.cmd('tabnext') end
M.jump_tabprev = function() vim.cmd('tabprevious') end
-- TODO:
-- M.jump_termnext = function() vim.cmd('FloatermNext') end
-- M.jump_termprev = function() vim.cmd('FloatermPrev') end

M.qf_cnewer = function() vim.cmd('cnewer') end
M.qf_colder = function() vim.cmd('colder') end
M.qf_global = function() greputils.qf_filter({ invert = false }) end
M.qf_vglobal = function() greputils.qf_filter({ invert = true }) end

M.run_align = function()
	bufutil.set_visual(bufutil.get_visual())
	vim.cmd([['<,'>EasyAlign]])
end

-- stylua: ignore start
M.toggle_dapui       = daputil.toggle_ui
M.debug_start        = daputil.debug_start
M.debug_restart      = daputil.debug_restart
M.debug_terminate    = daputil.debug_terminate
M.debug_pause        = daputil.debug_pause
M.debug_step_into    = daputil.debug_step_into
M.debug_step_out     = daputil.debug_step_out
M.debug_step_over    = daputil.debug_step_over
M.debug_bp_toggle    = daputil.debug_bp_toggle
M.debug_bp_condition = daputil.debug_bp_condition
M.debug_bp_clear     = daputil.debug_bp_clear
M.debug_bp_list      = daputil.debug_bp_list
M.debug_hover        = daputil.debug_hover
M.debug_preview      = daputil.debug_preview
M.debug_to_cursor    = daputil.debug_to_cursor
M.debug_open_log     = daputil.debug_open_log
M.debug_toggle_repl  = daputil.debug_toggle_repl
-- stylua: ignore end

M.switch_project = require('utils.pickers.project')
M.messages = function() vim.cmd('Messages') end
M.lsp_info = function() lsputil.open_config() end

M.run_code = function() vim.lsp.buf.code_action() end
M.run_enew = function() vim.cmd('enew') end
M.run_format = function()
	if vim.fn.mode() == 'n' then
		vim.cmd([[Neoformat]])
	else
		bufutil.set_visual(bufutil.get_visual())
		vim.cmd([['<,'>Neoformat]])
	end
end
M.run_grep = function() greputils.grep_pattern(nil) end
M.run_gx = function() vim.cmd('Browse') end

M.run_make = function()
	return bufutil.is_file() and vim.cmd([[make %]])
		or vim.notify('not implemented', vim.log.levels.WARN)
end

M.run_maximize = function() vim.cmd([[resize +999 | vertical resize +999]]) end

M.run_neogen = function() vim.cmd('Neogen') end

M.run_rename = function()
	return lsputil.is_attached() and vim.lsp.buf.rename()
		or vim.notify('not implemented', vim.log.levels.WARN)
end

M.run_replace = function()
	local text = tostring(vim.fn.expand('<cword>'))
	if vim.fn.mode() == 'v' then
		text = table.concat(bufutil.get_visual().text, '\\n')
		text = string.gsub(text, '\r', '\\r')
		text = string.gsub(text, '\t', '\\t')
	end
	local repl = string.gsub(text, '\\n', '\\r')
	local cmd = '<esc>:%s/'
		.. text
		.. '/'
		.. repl
		.. '/g<left><left><bs>'
		.. string.sub(text, -1, -1)
	cmd = vim.api.nvim_replace_termcodes(cmd, true, true, true)
	vim.api.nvim_feedkeys(cmd, 'n', true)
end

M.run_source = function() vim.cmd.source('%') end

M.run_spawn = function() vim.fn.system('st >/dev/null 2>&1 & disown $!') end

--@deprecated unused?
M.run_star = function()
	local pattern = bufutil.is_visual()
			and table.concat(bufutil.get_visual().text, '')
		or tostring(vim.fn.expand('<cword>'))
	greputils.grep_pattern(pattern)
end

M.run_star_git = function()
	local pattern = bufutil.is_visual()
			and table.concat(bufutil.get_visual().text, '')
		or tostring(vim.fn.expand('<cword>'))
	greputils.grep_pattern(pattern, 'git')
end

M.run_term = function() vim.cmd('term') end

M.run_tabnew = function() vim.cmd('tabnew') end

M.run_zknew = function()
	local title = vim.fn.input('Title: ')
	if title ~= nil and title ~= '' then
		require('zk.commands').get('ZkNew')({ title = title })
	end
end

M.show_highlight = function() lsputil.wrap(vim.lsp.buf.document_highlight) end

M.show_hover = function() lsputil.wrap(vim.lsp.buf.hover) end

M.show_signature = function() lsputil.wrap(vim.lsp.buf.signature_help) end

M.toggle_ntree = function()
	require('nvim-tree.api').tree.toggle({ focus = false })
end

M.toggle_oil = function() vim.cmd([[Oil]]) end

M.toggle_option = require('utils.pickers.options')

M.toggle_outline = function()
	return lsputil.is_attached()
			and bufutil.toggle('Outline', {
				focus = false,
				cb = function()
					vim.cmd('SymbolsOutlineOpen')
					local group = vim.api.nvim_create_augroup(
						'toggle-symbols-outline',
						{ clear = true }
					)
					local winid = vim.api.nvim_get_current_win()
					vim.api.nvim_create_autocmd({ 'BufEnter' }, {
						group = group,
						callback = vim.schedule_wrap(function()
							local ft = vim.bo.filetype
							if ft == 'Outline' then
								vim.api.nvim_del_augroup_by_id(group)
								vim.api.nvim_set_current_win(winid)
							end
						end),
					})
				end,
			})
		or vim.notify('lsp not attached or not ready', vim.log.levels.WARN)
end

M.toggle_quickfix = function() bufutil.toggle('qf', { cb = qfutil.open }) end
M.toggle_term = function() require('utils.term').toggle() end

M.new_term = function() require('utils.term').new_term() end

-- Open keyword under cursor or selection. Tries to resolve cword and cWORD
-- as such:
--
-- vim.o.keywordprg
--     o.keywordprg
--       keywordprg
--
-- This is required because of https://github.com/neovim/neovim/pull/24331
M.keywordprg = function()
	if not vim.o.keywordprg then
		return vim.notify('info: keywordprg not set', vim.log.levels.WARN)
	end
	local cexprs = {}
	vim.list_extend(cexprs, bufutil.get_cexprs({ reverse = true }))
	vim.list_extend(cexprs, bufutil.get_cexprs({ reverse = false }))
	for _, pattern in ipairs(cexprs) do
		local status =
			pcall(vim.api.nvim_exec2, vim.o.keywordprg .. ' ' .. pattern, {})
		if status then return end
	end
	vim.notify(vim.o.keywordprg .. ' not found', vim.log.levels.WARN)
end

-- vim.o.keywordprg
-- vim.o.keywordpr
-- vim.o.keywordp
-- ...
M.keywordprg_alt = function()
	if not vim.o.keywordprg then
		return vim.notify('info: keywordprg not set', vim.log.levels.WARN)
	end
	local search = bufutil.is_visual()
			and table.concat(bufutil.get_visual().text, '')
		or tostring(vim.fn.expand('<cWORD>'))
	local cexprs = {}
	for i = #search, 2, -1 do
		table.insert(cexprs, search:sub(1, i))
	end
	for _, pattern in ipairs(cexprs) do
		log(pattern)
		local status =
			pcall(vim.api.nvim_exec2, vim.o.keywordprg .. ' ' .. pattern, {})
		if status then return vim.notify('keywordprg ' .. pattern) end
	end
	vim.notify(vim.o.keywordprg .. ' not found', vim.log.levels.WARN)
end

M.help = function(key)
	return function()
		vim.cmd('WhichKey ' .. key)
		-- v2.1.0
	end
end

M.clear_marks = function()
	vim.cmd('delmarks a-z0-9 | echo "Marks cleared" | wshada!')
end

M.clear_buffers = bufutil.clear_buffers

M.compile = function()
	local args = bufutil.is_visual()
			and table.concat(bufutil.get_visual().text, '')
		or ''
	local cmd =
		vim.api.nvim_replace_termcodes(':Compile! ' .. args, true, true, true)
	vim.api.nvim_feedkeys(cmd, 'n', true)
end

M.recompile = function() vim.cmd('Recompile') end
M.open_compile = function() require('module.compile').open_compile() end

M.file_url = function()
	if vim.fn.mode() == 'n' then
		vim.cmd('Url')
	else
		vim.cmd('Url!')
		local cmd = vim.api.nvim_replace_termcodes('<esc>', true, true, true)
		vim.api.nvim_feedkeys(cmd, 'v', true)
	end
end

-- Only for npm now
M.npm_test_file = function()
	local fts = {
		javascript = true,
		javascriptreact = true,
		typescript = true,
		typescriptreact = true,
	}
	if fts[vim.bo.filetype] == nil then
		return vim.notify('Not a js/ts file', vim.log.levels.WARN)
	end
	local dir = vim.fn.getcwd()
	local cmd = 'npm run test -- ' .. vim.fn.expand('%:p')
	require('module.compile').compile(cmd, dir, true)
end

return M
