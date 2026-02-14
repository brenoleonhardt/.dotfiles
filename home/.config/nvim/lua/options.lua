--- Options

-- stylua: ignore start
vim.opt.autochdir      = true                          -- use file path as vim's dir
vim.opt.autoindent     = true                          -- new lines inherits indentation
vim.opt.bomb           = false                         -- ??? <feff>
vim.opt.clipboard      = 'unnamed,unnamedplus'         -- copy/pasting from x11 clipboard
vim.opt.cmdheight      = 1                             -- only 1 row for cmdline
vim.opt.colorcolumn    = { 78 }                        -- draw column at position
vim.opt.conceallevel   = 0                             -- shows |hyperlinks|
vim.opt.cursorline     = true                          -- highlights current line
vim.opt.encoding       = 'utf-8'                       -- set default internal encoding
vim.opt.fileformat     = 'unix'                        -- set default file format
vim.opt.fileencoding   = 'utf-8'                       -- default buffer file encoding
vim.opt.fileencodings  = {
	'utf-8',
	'latin1',
	'ucs-bom',
	'default'
}
-- vim.opt.fillchars      = 'fold:\\'                     -- make v:folddashes whitespace
vim.opt.foldcolumn     = 'auto:9'                      -- show fold level in gutter
vim.opt.foldlevelstart = 99                            -- make folds open initially
vim.opt.foldmethod     = 'marker'                      -- default fold method using {{{}}}
vim.opt.foldminlines   = 1
vim.opt.foldnestmax    = 6
vim.opt.foldopen       = {                             -- movements to open closed folds
  'insert',
  'quickfix',
  'mark',
  'search',
  'tag',
  'undo'
}
vim.opt.formatoptions  = 'j,n,q'                       -- defaults for formatting text
vim.opt.grepformat     = '%f:%l:%c:%m'                 -- format for grep in quickfix
vim.opt.grepprg        = table.concat({
  'rg',
  '--hidden',
  '--smart-case',
  '--color=never',
  '--no-heading',
  '--column',
  '--with-filename',
  '--line-number',
  '-e',
  '$*'
}, ' ')
vim.opt.hidden         = true                          -- hide files don't prompt for save
vim.opt.history        = 10000                         -- keep more history in q:
vim.opt.hlsearch       = true                          -- keep search highlighted
vim.opt.ignorecase     = true                          -- ignore case when searching
vim.opt.inccommand     = 'nosplit'                     -- preview subsittution as you type
vim.opt.incsearch      = true                          -- search as chars are entered
vim.opt.keywordprg     = ':help'                       -- use help as default for <S-k>
vim.opt.laststatus     = 3                             -- show a single statusline
vim.opt.lazyredraw     = true                          -- do not redraw during macros
vim.opt.linebreak      = true                          -- don't break word when wrapping
vim.opt.listchars      = {
  tab                  = [[» ]],
  trail                = '¬',
  nbsp                 = '␣',
  extends              = '›',
  precedes             = '‹',
  -- eol                  = '$',
}
vim.opt.list           = true                          -- actually use listchars
vim.opt.more           = true                          -- show --more-- to scroll messages
vim.opt.expandtab      = false                         -- don't expands tabs as spaces
vim.opt.joinspaces     = false                         -- always insert 1 spc on join J
vim.opt.showmode       = false                         -- don't show --INSERT-- message
vim.opt.smartindent    = false                         -- ??? this fixes issue with > #
vim.opt.spell          = false                         -- disable spell check
vim.opt.splitbelow     = false                         -- :sp creates top split
vim.opt.startofline    = false                         -- do not reset col when moving
vim.opt.wrapscan       = false                         -- search next stops at end of file
vim.opt.wrap           = false                         -- don't wrap lines
vim.opt.number         = true                          -- set numeration of lines
vim.opt.path           = '**'                          -- extend path to glob **
vim.opt.pumheight      = 12                            -- max num of items in popup menu
vim.opt.pumwidth       = 15                            -- min popup menu width
vim.opt.relativenumber = true                          -- set relative numbers
vim.opt.report         = 0                             -- always report on :substitute
-- vim.opt.scrolloff      = 999                           -- keep cursor centered
vim.opt.scrolloff      = 0                             -- keep cursor centered
vim.opt.shellcmdflag   = '-O globstar -c'
vim.opt.shiftwidth     = 4                             -- number of spaces used by = op.
vim.opt.shortmess:append('cs')                         -- remove annoying messages
vim.opt.showbreak      = '↪ '                          -- symbol for wrapped lines
vim.opt.showcmd        = true                          -- show commands being used
vim.opt.showmatch      = true                          -- highlights matches [{()}]
vim.opt.signcolumn     = 'yes:1'                       -- keep always one signcolumn
vim.opt.smartcase      = true                          -- smart case for search
vim.opt.splitright     = true                          -- :vsp creates right split
vim.opt.splitkeep      = 'topline'                     -- when splitting, keep window static
vim.opt.suffixesadd    = ''                            -- clean suffixes
vim.opt.tabstop        = 4                             -- display tab as 4 spaces
vim.opt.tags           = 'tags;~'                      -- search tags file up to $HOME
vim.opt.termguicolors  = true
vim.opt.textwidth      = 78                            -- norm gq width. see formatoptions
vim.opt.undolevels     = 500                           -- keep more undos
vim.opt.updatetime     = 300                           -- time for writting swap to disk
vim.opt.timeout        = false
vim.opt.timeoutlen     = 0
vim.opt.virtualedit    = 'onemore'                     -- put cursor where there is no char
vim.opt.visualbell     = true
vim.opt.wildignore     = {                             -- ignore pattern using vimgrep
  '.git',
  'node_modules',
  '*.o',
  '*.obj'
}
vim.opt.wildmenu       = true                          -- tab help in cmdline
vim.opt.wildmode       = 'full'                        -- how wildmenu appears

vim.opt.shada = "!,'100,<50,s10,h"

-- Extras
vim.g.vim_indent_cont  = 4                             -- in vimscript, \ indents shiftwidth
vim.g.c_syntax_for_h   = 1                             -- recognize .h as c file
-- stylua: ignore end

vim.env.MANPAGER = '' -- unset nvim manpager
-- vi:cc=92
