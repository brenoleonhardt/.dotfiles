---@diagnostic disable: redefined-local
local bufutil = require('utils.buf')

local M = {}

M.gitlink = function()
	-- Get and validate file path
	local full_path = vim.fn.expand('%:p')
	if vim.fn.filereadable(full_path) ~= 1 then
		return warn('File is not readable')
	end

	-- Execute git command and return result or error
	local function git_exec(args, error_context)
		local result = vim.system({ 'git', unpack(args) }, { text = true }):wait()
		if result.code ~= 0 then
			return nil, (error_context or '') .. (result.stderr or '')
		end
		return vim.trim(result.stdout)
	end

	-- Get git repository root
	local base_path, err = git_exec({ 'rev-parse', '--show-toplevel' })
	if not base_path then return warn(err) end
	base_path = base_path .. '/'

	-- Get remote URL
	local remote_url, err = git_exec({ 'remote', 'get-url', 'origin' })
	if not remote_url then return warn(err) end

	-- Strip -* from github URLs (e.g. github-work.com)
	remote_url = remote_url:gsub('github%-[^%.]+%.com', 'github.com')

	-- Get current commit SHA
	local commit_sha, err = git_exec({ 'rev-parse', 'HEAD' })
	if not commit_sha then return warn(err) end

	-- Parse owner and repo from remote URL
	-- Handles both SSH (git@github.com:owner/repo.git) and HTTPS (https://github.com/owner/repo.git)
	local owner, repo =
		remote_url:match('github%.com[:/]([%w%-_%.]+)/([%w%-_%.]+)%.git$')
	if not owner or not repo then
		return warn(
			'Could not parse GitHub owner/repo from remote URL: ' .. remote_url
		)
	end

	-- Calculate relative path from repo root
	local relative_path = full_path:sub(#base_path + 1)

	-- Determine line range (current line or visual selection)
	local line_start, line_end
	if bufutil.is_visual() then
		local visual = bufutil.get_visual()
		line_start = tostring(visual.start.line)
		line_end = tostring(visual.finish.line)
		bufutil.escape_visual()
	else
		line_start = tostring(vim.fn.line('.'))
		line_end = line_start
	end

	-- Construct and log permalink (github only for now)
	local permalink = string.format(
		'https://github.com/%s/%s/blob/%s/%s#L%s-L%s',
		owner,
		repo,
		commit_sha,
		relative_path,
		line_start,
		line_end
	)

	local command = vim.loop.os_uname().sysname == 'Darwin' and 'open'
		or 'xdg-open'
	vim.system({ command, permalink }, { text = true })
end

return M
