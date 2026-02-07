-- local actions = require('oil.actions')
local oil = require('oil')

oil.setup({
	-- TODO: move this to keymap
	keymaps = {
		['-'] = 'actions.parent',
		-- ['e'] = 'actions.select',
		['<cr>'] = 'actions.select',

		['<c-s>'] = 'actions.select_split',
		['<c-t>'] = 'actions.select_tab',
		["<C-l>"] = "actions.preview",

		['g?'] = 'actions.show_help',
		['gx'] = 'actions.open_external',
		['<c-c>'] = 'actions.close', -- not needed, C-o/C-i does the job
		['zh'] = 'actions.toggle_hidden',
	},
	buf_options = {
		buflisted = true,
		bufhidden = 'hide',
		swapfile = false,
	},
	default_file_explorer = true,
	skip_confirm_for_simple_edits = true,
	use_default_keymaps = false,
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	desc = 'Autochdir in oil',
	pattern = { 'oil://*' },
	group = vim.api.nvim_create_augroup('oil-custom', { clear = true }),
	callback = function() vim.cmd('cd ' .. oil.get_current_dir()) end,
	nested = true,
})
