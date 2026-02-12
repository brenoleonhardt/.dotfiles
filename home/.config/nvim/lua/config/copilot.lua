if vim.env.COPILOT_ENABLED ~= '1' then return end

require('copilot').setup({
	copilot_node_command = vim.fn.expand('$HOME')
		.. '/.asdf/installs/nodejs/23.3.0/bin/node',
	filetypes = {
		['*'] = true,
	},
	panel = { enabled = false },
	suggestion = {
		enabled = true,
		auto_trigger = true,
		accept = false,
		debounce = 50,
	},
	server_opts_overrides = {
		settings = {
			advanced = {
				listCount = 0, -- #completions for panel
				inlineSuggestCount = 1, -- #completions for getCompletions
			},
		},
	},
})

-- FIX: whenever entering insert mode, copilot won't show suggestions
--      until a key is pressed, so we force it to show suggestions.
--      the catch here is that time timer timeout must be greater than
--      the copilot's debounce

local feed = vim.schedule_wrap(
	function() vim.api.nvim_exec_autocmds('CursorMovedI', {}) end
)

local trigger = vim.schedule_wrap(function()
	local timer = vim.uv.new_timer()
	timer:start(75, 0, feed)
end)

vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
	nested = true,
	desc = 'Generate CompleteChanged on insert enter',
	group = vim.api.nvim_create_augroup('alert-copilot', { clear = true }),
	pattern = '[ns]:i',
	callback = trigger,
})
