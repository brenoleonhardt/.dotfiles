--- Keymaps

local maps = require('utils.maps')
local treeutil = require('utils.treesitter')

-- stylua: ignore
local keyboard = {
  leader = ' ',
  prefixes = { -- [[
    d     = { name = ' debug'  },
    f     = { name = ' find'   },
    g     = { name = '󰊢 git'    },
    w     = { name = '󰖳 window' },
  }, -- ]]
  mappings = {
    action = { -- [[
      { { 'n',     }, '<c-n>',          maps.find_mark,          { desc = ' marks'                } },
      -- { { 'n',     }, '<c-n>',          maps.focus_terminal,     { desc = ' terminal'             } }, -- TODO
      { { 'n',     }, '<c-]>',          maps.goto_definition,    { desc = ' definition'           } },
      { { 'n',     }, '<c-k>',          maps.show_hover,         { desc = ' hover'                } },
      { { 'n',     }, 'gr',             maps.goto_references,    { desc = ' references'           } },
      { { 'n',     }, 'gi',             maps.goto_implementation,{ desc = ' implementation'       } },
      { { 'n',     }, 'gy',             maps.goto_typedef,       { desc = ' typedef'              } },
      { { 'n',     }, 'gO',             maps.qf_buf_symbols,     { desc = ' buf-symbols'          } }, -- revisit (useful?)
      { { 'n', 'x' }, 'ga',             maps.run_align,          { desc = ' align'                } },
      { { 'n', 'x' }, 'gx',             maps.run_gx,             { desc = ' browse',              } },
      { { 'n',     }, 'gm',             maps.messages,           { desc = ' messages'             } }, -- forgot (useful)
      { { 'n',     }, 'g?',             maps.help('g'),          { desc = ' which-key'            } },
      { { 'n', 'x' }, 'g]',             maps.run_star_git,       { desc = ' star git',            } },
      { { 'n', 'x' }, 'gp',             maps.file_url,           { desc = ' file-url'             } },
      { { 'n',     }, '<leader>t',      maps.run_term,           { desc = ' run-term'             } }, -- revisit
      { { 'n',     }, '<leader>e',      maps.errors_buffer,      { desc = ' errors-buf'           } }, -- todo: toggle
      { { 'n',     }, '<leader>c',      maps.clear_marks,        { desc = ' clear-marks'          } }, -- revisit (unsued)
      { { 'n',     }, '<leader>x',      maps.clear_buffers,      { desc = ' hover'                } }, -- revisit (unused)
      { { 'n', 'x' }, '<leader>r',      maps.run_rename,         { desc = ' rename'               } },
      { { 'n', 'x' }, '<leader>s',      maps.run_replace,        { desc = ' replace'              } },
      { { 'n', 'x' }, '<leader>z',      maps.run_zknew,          { desc = ' zk-new',              } },
      { { 'n',     }, '<leader>m',      maps.run_make,           { desc = ' make',                } }, -- revisit (use compile)
      { { 'n', 'x' }, '<leader>a',      maps.run_code,           { desc = ' code-action'          } },
      { { 'n', 'x' }, '<leader>i',      maps.run_neogen,         { desc = ' neogen',              } },
      { { 'n', 'x' }, '<leader>=',      maps.run_format,         { desc = ' format'               } },
      { { 'n', 'x' }, '<leader>/',      maps.run_grep,           { desc = ' grep',                } },
      { { 'n', 'x' }, '<leader>]',      maps.compile,            { desc = ' compile',             } },
      { { 'n'      }, '<leader>[',      maps.recompile,          { desc = ' recompile',           } },
      { { 'n',     }, '<c-p>',          maps.open_compile,       { desc = ' open compile'         } },
      { { 'n',     }, '<leader>\\',     maps.npm_test_file,      { desc = ' npm-test-file'        } }, -- revisit (use test)
      { { 'n',     }, '<leader>?',      maps.help('<leader>'),   { desc = ' which-key'            } },
    }, -- ]]
    debug = { -- [[
      --[[ { {'n',      }, '<leader>dd',     maps.debug_start,        { desc = '/ start/continue'     } },
      { {'n',      }, '<leader>dr',     maps.debug_restart,      { desc = '/ restart/last'       } },
      { {'n',      }, '<leader>dx',     maps.debug_terminate,    { desc = ' terminate'            } },
      { {'n',      }, '<leader>ds',     maps.debug_pause,        { desc = '󱇫 pause thread'         } },
      { {'n',      }, '<leader>di',     maps.debug_step_into,    { desc = '󰆹 step into'            } },
      { {'n',      }, '<leader>do',     maps.debug_step_out,     { desc = '󰆸 step out'             } },
      { {'n',      }, '<leader>dn',     maps.debug_step_over,    { desc = '󰆷 step over'            } },
      { {'n',      }, '<leader>db',     maps.debug_bp_toggle,    { desc = ' breakpoint toggle'    } },
      { {'n',      }, '<leader>dv',     maps.debug_bp_condition, { desc = '󰊕 breakpoint condition' } },
      { {'n',      }, '<leader>dc',     maps.debug_bp_clear,     { desc = ' breakpoint clear'     } },
      { {'n',      }, '<leader>dq',     maps.debug_bp_list,      { desc = ' breakpoint list'      } },
      { {'n',      }, '<leader>dk',     maps.debug_hover,        { desc = '󱄑 info hover'           } },
      { {'n',      }, '<leader>dp',     maps.debug_preview,      { desc = '󰩣 info preview'         } },
      { {'n',      }, '<leader>d.',     maps.debug_to_cursor,    { desc = '󰇀 run to cursor'        } },
      { {'n',      }, '<leader>dm',     maps.debug_open_log,     { desc = ' dap log'              } },
      { {'n',      }, '<leader>d`',     maps.debug_toggle_repl,  { desc = ' toggle repl'          } },
      { {'n',      }, '<leader>d?',     maps.help('<leader>d'),  { desc = ' which-key'            } }, ]]
    }, -- ]]
    find = { -- [[
      { { 'n',     }, '<leader>fb',     maps.find_buffers,       { desc = ' buffer'               } },
      { { 'n',     }, '<leader>fc',     maps.find_recent,        { desc = ' recent'               } },
      { { 'n',     }, '<leader>fp',     maps.find_rfiles,        { desc = ' git-files'            } },
      { { 'n',     }, '<leader>fg',     maps.find_gitstatus,     { desc = ' git-diffs'            } },
      { { 'n',     }, '<leader>fh',     maps.find_helptag,       { desc = ' helptags'             } },
      { { 'n',     }, '<leader>fl',     maps.find_config,        { desc = ' lua-configs'          } },
      { { 'n',     }, '<leader>fm',     maps.find_make,          { desc = ' makefile'             } },
      { { 'n',     }, '<leader>ff',     maps.find_pfiles,        { desc = ' project-files'        } },
      { { 'n',     }, '<leader>fr',     maps.switch_project,     { desc = ' projects'             } },
      { { 'n',     }, '<leader>f.',     maps.find_curdir,        { desc = ' curdir-files'         } },
      { { 'n',     }, '<leader>fd',     maps.find_directory,     { desc = ' directory'            } },
      { { 'n',     }, '<leader>f/',     maps.find_grep,          { desc = ' grep'                 } },
      { { 'n',     }, '<leader>fz',     maps.find_zk,            { desc = ' zk-notes'             } },
      { { 'n',     }, '<leader>f`',     maps.find_mark,          { desc = ' marks'                } },
      { { 'n',     }, '<leader>fs',     maps.find_doc_symbol,    { desc = ' doc-symbol'           } },
      { { 'n',     }, '<leader>fw',     maps.find_ws_symbol,     { desc = ' ws-symbol'            } },
      { { 'n',     }, '<leader>f?',     maps.help('<leader>f'),  { desc = ' which-key'            } },
    }, -- ]]
    git = { -- [[
      { { 'n',     }, '<leader>gg',     maps.git_fugitive,       { desc = ' fugitive'             } },
      { { 'n',     }, '<leader>gl',     maps.git_log,            { desc = ' logs'                 } },
      { { 'n',     }, '<leader>gL',     maps.git_clog,           { desc = ' clog'                 } },
      { { 'n',     }, '<leader>gs',     maps.git_stage,          { desc = ' stage'                } },
      { { 'n',     }, '<leader>gu',     maps.git_unstage,        { desc = ' unstage'              } },
      { { 'n',     }, '<leader>gp',     maps.git_preview,        { desc = ' preview'              } },
      { { 'n',     }, '<leader>gr',     maps.git_reset,          { desc = ' reset'                } },
      { { 'n',     }, '<leader>gb',     maps.git_blame,          { desc = ' blame'                } },
      { { 'n', 'x' }, '<leader>gy',     maps.git_link,           { desc = ' gitlink'              } },
      { { 'n',     }, '<leader>g?',     maps.help('g'),          { desc = ' which-key'            } },
    }, -- ]]
    quickfix = { -- [[
      { { 'n',     }, 'qf',             maps.qf_global,          { desc = ' global'               } },
      { { 'n',     }, 'qv',             maps.qf_vglobal,         { desc = ' vglobal'              } },
      { { 'n',     }, 'qp',             maps.qf_colder,          { desc = ' colder'               } },
      { { 'n',     }, 'qn',             maps.qf_cnewer,          { desc = ' cnewer'               } },
      { { 'n',     }, 'q?',             maps.help('<leader>q'),  { desc = ' which-key'            } },
    }, -- ]]
    window = { -- [[
      { { 'n',     }, '<leader>w',      '<c-w>',                 {                                 } },
      { { 'n',     }, '<leader>wt',     maps.run_tabnew,         { desc = ' tabnew',              } },
      { { 'n',     }, '<leader>we',     maps.run_enew,           { desc = ' enew',                } },
      { { 'n',     }, '<leader>wm',     maps.run_maximize,       { desc = ' maximize',            } },
      { { 'n',     }, '<leader>w?',     maps.help('<c-w>'),      { desc = ' which-key'            } },
    }, -- ]]
    jump = { -- [[
      -- { { 'n',     }, ']b',             maps.jump_bufnext,      { desc = '󰒭 buffer'               } }, -- unused
      -- { { 'n',     }, '[b',             maps.jump_bufprev,      { desc = '󰒮 buffer'               } },
      { { 'n',     }, ']c',             maps.jump_chunknext,    { desc = '󰒭 chunk'                } },
      { { 'n',     }, '[c',             maps.jump_chunkprev,    { desc = '󰒮 chunk'                } },
      { { 'n',     }, ']e',             maps.jump_errornext,    { desc = '󰒭 error'                } },
      { { 'n',     }, '[e',             maps.jump_errorprev,    { desc = '󰒮 error'                } },
      { { 'n',     }, ']q',             maps.jump_qfnext,       { desc = '󰒭 qf-entry'             } },
      { { 'n',     }, '[q',             maps.jump_qfprev,       { desc = '󰒮 qf-entry'             } },
      -- { { 'n',     }, ']`',             maps.jump_termnext,     { desc = '󰒭 terminal'             } },
      -- { { 'n',     }, '[`',             maps.jump_termprev,     { desc = '󰒮 terminal'             } },
      { { 'n',     }, ']?',             maps.help(']'),         { desc = ' which-key'            } },
      { { 'n',     }, '[?',             maps.help('['),         { desc = ' which-key'            } },
    }, -- ]]
    toggles = { -- [[
      { { 'n',     }, '<leader><tab>',  maps.toggle_outline,    { desc = ' outline'              } },
      { { 'n',     }, '<leader>q',      maps.toggle_quickfix,   { desc = ' quickfix'             } },
      { { 'n',     }, '<leader>n',      maps.toggle_ntree,      { desc = ' ntree'                } },
      -- { { 'n',     }, '<leader>u',      maps.toggle_dapui,      { desc = ' dapui'                } },
      { { 'n',     }, '<leader>o',      maps.toggle_option,     { desc = ' option'               } },
      { { 'n',     }, '<leader>`',      maps.toggle_term,       { desc = ' terminal'             } },
      { { 'n',     }, '<leader>~',      maps.new_term,          { desc = '󱓞 newterm'              } },
      { { 'n',     }, '-',              maps.toggle_oil,        { desc = '󱓞 oil'                  } },
    }, -- ]]
    defaults = { -- [[
      { { 'i',     }, 'jk',         '<c-[>l'                                 },
      { { 'i',     }, 'kj',         '<c-[>l'                                 },
      { { 's',     }, 'jk',         '<esc>'                                  },
      { { 's',     }, 'kj',         '<esc>'                                  },
      { { 'c',     }, 'jk',         '<esc>'                                  },
      { { 'c',     }, 'kj',         '<esc>'                                  },
      { { 't',     }, 'jk',         [[<C-\><C-n>]]                           },
      { { 't',     }, 'kj',         [[<C-\><C-n>]]                           },
      { { 't',     }, '<esc>',      [[<C-\><C-n>]]                           },
      { { 't',     }, '<esc>',      [[<C-\><C-n>]]                           },
      { { 'x',     }, '<',          '<gv'                                    },
      { { 'x',     }, '>',          '>gv'                                    },
      { { 'n',     }, '>',          '>>'                                     },
      { { 'n',     }, '<',          '<<'                                     },
      { { 'n',     }, '',         '<cmd>nohlsearch<cr>'                    },
      { { 'n',     }, 'Y',          'v$hy'                                   },
      { { 'n',     }, 'Q',          '<Nop>'                                  },
      { { 'x',     }, 'p',          'pgvy'                                   },
      { { 'n', 'x' }, 'K',           maps.keywordprg                         },
      { {      'x' }, '=',           maps.run_format,                        },
      { { 's',     }, '<bs>',       '<bs>i'                                  },
      { { 'x',     }, '*',          [["zy/\V<C-r>=escape(@z, '\/')<cr><cr>]] },

    }, -- ]]
    cmdline = { -- [[
      -- TODO: ~/notes/nthmn3k7-linux-terminal-keybindings.md
    } -- ]]
  },
  abbreviations = { -- [[
    go = { -- [[
      ['eq']  = ':=',
      ['ne']  = '!=',
      ['ife'] = 'if err != nil {<cr><cr>}<up><tab>',
      ['fn']  = 'func() {}<left><cr>.<cr><up><tab><del>',
    } -- ]]
  }, -- ]]
  filetypes = { -- [[
    norg = {},
  }, -- ]]
	unmappings = {  -- [[
      { { 'n',     }, 'grn' },
      { { 'n',     }, 'grt' },
      { { 'n', 'x' }, 'gra' },
      { { 'n',     }, 'grr' },
      { { 'n',     }, 'gri' },
      { { 'i',     }, '<c-s>' },
      --{ { 'n',     }, 'gO' }
	} -- ]]
}

-- [[ setup

vim.g.mapleader = keyboard.leader
vim.z.keyboard = keyboard

for _, group in pairs(keyboard.mappings) do
	for _, map in pairs(group) do
		local status, _ = pcall(vim.keymap.set, unpack(map))
		if not status then
			vim.notify(
				'Failed to set keymap: ' .. vim.inspect(map),
				vim.log.levels.ERROR
			)
		end
	end
end

for _, map in pairs(keyboard.unmappings) do
	pcall(vim.keymap.del, unpack(map))
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileType' }, {
	desc = 'Load buffer local abbreviations',
	group = vim.api.nvim_create_augroup('abbreviations', { clear = true }),
	pattern = vim.tbl_keys(keyboard.abbreviations),
	callback = function(ev)
		local ft = vim.api.nvim_get_option_value('ft', { buf = ev.buf })
		for lhs, rhs in pairs(keyboard.abbreviations[ft]) do
			vim.keymap.set(
				'ia',
				lhs,
				function() return treeutil.is_comment() and lhs or rhs end,
				{ buffer = ev.buf, expr = true }
			)
		end
	end,
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileType' }, {
	desc = 'Load buffer local mappings',
	group = vim.api.nvim_create_augroup('filetype-mappings', { clear = true }),
	pattern = vim.tbl_keys(keyboard.filetypes),
	callback = function(ev)
		local ft = vim.api.nvim_get_option_value('ft', { buf = ev.buf })
		for _, map in pairs(keyboard.filetypes[ft]) do
			map[4] = map[4] or {}
			map[4].buffer = ev.buf
			local status, _ = pcall(vim.keymap.set, unpack(map))
			if not status then
				vim.notify(
					'Failed to set buffer local keymap: ' .. vim.inspect(map),
					vim.log.levels.ERROR
				)
			end
		end
	end,
})
-- ]]

--[[ -- 1-9 marks override with A-I
for i = 1, 9 do
	local mark = string.char(string.byte('A') + i - 1)
	vim.keymap.set('n', 'm' .. tostring(i), function()
		vim.cmd('mark ' .. mark)
		vim.notify('Set mark ' .. mark, vim.log.levels.INFO)
	end, { desc = 'Set mark ' .. mark })
	vim.keymap.set('n', '`' .. tostring(i), function()
		vim.cmd('normal! `' .. mark)
		vim.notify('Jumped to mark ' .. mark, vim.log.levels.INFO)
	end, { desc = 'Jump to mark ' .. mark })
end
]]

--[[ *:map-arguments* reference
  buffer: current buffer only                                   (default false)
  remap:  recursive mapping                                     (default false)
  nowait: don't wait for other mappings, immediatly evaluate    (default false)
  silent: don't echo the command                                (default false)
  script: use {rhs} mappings defined in the script - <SID>      (default false)
  expr:   evaluate {rhs} as an expression                       (default false)
  unique: don't remap if already mapped                         (default false)
  desc:   human-readable description                            (default '')
--]]

-- vim:tw=103:cc=103:fdm=marker:fmr=[[,]]
