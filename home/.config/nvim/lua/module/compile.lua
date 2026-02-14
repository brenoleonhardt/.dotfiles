--- Compile
--
-- Provides :C/Compile <cmd>  - works like M-x compile
--          :R/Recompile[!]
--
-- Bang focus on the compilation window
--
assert(vim.z.mloaded('log'), 'log module is not loaded')
local complete_utils = require('utils.complete')
local strings_util = require('utils.strings')

local M = {}

local MAX_CWD_LEN = 30
local PRESERVE_HISTORY = true
local HISTORY_FILE = vim.fn.stdpath('data') .. '/compile_history'

---@diagnostic disable-next-line: redefined-local
local function dedupe(history)
	local cache = {}
	for i = #history, 1, -1 do
		local item = history[i]
		local key = item.cwd .. '//' .. item.cmd
		if cache[key] ~= nil then
			table.remove(history, i)
		else
			cache[key] = true
		end
	end
end

local history = (function()
	if not PRESERVE_HISTORY then return {} end
	local exists = vim.fn.filereadable(HISTORY_FILE) == 1
	if not exists then return {} end
	---@type string[]
	local commands = vim.fn.readfile(HISTORY_FILE)
	local history = {}
	for _, command_str in ipairs(commands) do
		local command = vim.json.decode(command_str)
		table.insert(history, command)
	end
	dedupe(history)
	return history
end)()

local function short_path(cwd)
	local str = strings_util.truncate_path(cwd, MAX_CWD_LEN)
	local offset = string.sub(str, 1, 3) == '…' and 2 or 0
	return str, offset
end

local function find_compile_window()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	for _, win_id in ipairs(wins) do
		local bufnr = vim.api.nvim_win_get_buf(win_id)
		local cmd = vim.fn.getbufvar(bufnr, 'compile')
		if cmd ~= '' then return win_id end
	end
	return nil
end

local function itemize(max_len)
	return function(idx, item)
		return string.format(
			'%-5s %-' .. tostring(max_len + item.offset) .. 's  $ %s',
			'[#' .. idx .. ']',
			item.short,
			item.cmd
		)
	end
end

local function change_dir(dir)
	vim.cmd([[silent! lcd ]] .. dir)
	vim.cmd([[silent! cd  ]] .. dir)
	vim.cmd([[silent! tc  ]] .. dir)
end

local function get_max_len(items)
	return vim
		.iter(items)
		:map(function(item) return string.len(item.short) - item.offset end)
		:fold(0, math.max)
end

M.compile = function(cmd, cwd, focus)
	if vim.fn.isdirectory(cwd) ~= 1 then
		return warn('Invalid directory: ' .. cwd)
	end
	local win_id = find_compile_window()
	if win_id ~= nil then
		vim.api.nvim_set_current_win(win_id)
		change_dir(cwd)
		vim.cmd('silent! te! ' .. cmd)
	else
		change_dir(cwd)
		vim.cmd('silent! bo te! ' .. cmd)
	end
	local bufnr = vim.fn.bufnr()
	vim.api.nvim_buf_set_var(bufnr, 'compile', cmd)
	local pid = vim.fn.getbufvar(vim.fn.bufnr(), 'terminal_job_pid')
	local short, offset = short_path(cwd)
	local command = {
		bufnr = bufnr,
		cwd = cwd,
		cmd = cmd,
		pid = pid,
		short = short,
		offset = offset,
	}
	table.insert(history, command)
	dedupe(history)
	if PRESERVE_HISTORY then
		local file = io.open(HISTORY_FILE, 'a')
		if file then
			file:write(vim.json.encode(command) .. '\n')
			file:close()
		end
	end
	vim.notify('Compile ' .. cmd)
	if not focus then vim.cmd('wincmd p') end
end

local function recompile_cmd(tbl)
	if #history == 0 then
		return warn('Command history is empty - cannot recompile')
	end
	local index, cmd = tbl.args:match('^%[#(%d+)%].*%$%s*(.*)$')
	if #tbl.fargs == 0 then index = #history end
	local item = history[tonumber(index)]
	if not item then return warn('Invalid recompile argument') end
	M.compile(cmd or item.cmd, item.cwd, tbl.bang)
end

local function recompile_complete_nr(_, L)
	local start = string.find(L, '%S%s') + 2
	local search = string.sub(L, start):gsub('^%s+', '')
	local items = vim
		.iter(history)
		:enumerate()
		:map(function(idx, item)
			item['idx'] = idx
			return item
		end)
		:rev()
		:filter(function(item) return string.match(item.cmd, search) end)
		:totable()

	local max_len = get_max_len(items)

	return vim
		.iter(items)
		:map(function(item) return item.idx, item end)
		:map(itemize(max_len))
		:totable()
end

for _, command in pairs({ 'C', 'Compile' }) do
	vim.api.nvim_create_user_command(
		command,
		function(tbl) M.compile(tbl.args, vim.fn.getcwd(), tbl.bang) end,
		{ bang = true, nargs = '+', complete = complete_utils.better_shellcmdline }
	)
end

for _, command in pairs({ 'R', 'Recompile' }) do
	vim.api.nvim_create_user_command(
		command,
		recompile_cmd,
		{ bang = true, nargs = '?', complete = recompile_complete_nr }
	)
end

vim.api.nvim_create_user_command('Compiled', function(tbl)
	local index, _ = tbl.args:match('^%[#(%d+)%].*%$%s*(.*)$')
	if #tbl.fargs == 0 then return end
	local item = history[tonumber(index)]
	if not item then return warn('Invalid compile history argument') end

	local win_id = find_compile_window()
	if win_id ~= nil then
		vim.api.nvim_set_current_win(win_id)
		vim.cmd('silent! b ' .. item.bufnr)
	else
		vim.cmd('silent! bo split | b ' .. item.bufnr)
	end
end, {
	bang = false,
	nargs = '+',
	complete = complete_utils.b_like_complete(function()
		return vim
			.iter(history)
			:enumerate()
			:filter(function(_, item) return vim.fn.bufexists(item.bufnr) == 1 end)
			:filter(
				function(_, item) return vim.fn.getbufvar(item.bufnr, 'compile') ~= '' end
			)
			:map(function(idx, item) return itemize(0)(idx, item) end)
			:rev()
			:totable()
	end),
})

return M
