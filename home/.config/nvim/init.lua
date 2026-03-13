--[[
██╗███╗   ██╗██╗████████╗   ██╗     ██╗   ██╗ █████╗
██║████╗  ██║██║╚══██╔══╝   ██║     ██║   ██║██╔══██╗
██║██╔██╗ ██║██║   ██║      ██║     ██║   ██║███████║
██║██║╚██╗██║██║   ██║      ██║     ██║   ██║██╔══██║
██║██║ ╚████║██║   ██║   ██╗███████╗╚██████╔╝██║  ██║
╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                              Breno Leonhardt Pacheco
                             brenoleonhardt@gmail.com
--]]

if vim.env.NVIM then
	io.stdout:write('Neovim is already running. Bailing out...\n\r')
	io.stdout:flush()
	os.exit(1)
end

if vim.g.vscode then return end

vim.z = {}
require('options')
require('packadd')
require('plugins')
require('keymaps')
vim.z.packadd({ { 'folke/which-key.nvim', as = 'which-key', tag = 'v2.1.0' } })

--[[
TODO:
	1. migrate to blink.cmp
	2. migrate to builtin lsp configuration
	3. migrate to builtin package manager - remove packadd
	4. replace hedyhli/outline.nvim
	5. verify which modules are being used
	6. migrate to folke's lazydev
	7. migrate to newer which-key
	8. write custom gitlinker
	9. write custom vim-floaterm
	10. integrate zeavim better, or write custom doc reader (wrap godoc, rustup doc, man, tldr)
	11. replace telescope
	12. remove unused packages
	13. cleanup unused keybindings and unused functionalities
	14. cleanup unused functions/modules
	15. establish snippet database

compile.lua:
- recompile use picker, allow two actions:
	1. re-execute
	2. change the command on the cmdline or cmdline buffer
- rename compiled to compile-list or compile-buffers and use picker to open it
- focus by default
- use <leader>m prefix mappings, mm calls the make picker, mc, mr, mb

makeprg:
- what is a good solution for this?

C-]:
add ctags / utags support
Ctrl-] → Jump to tag under cursor (:tag automatically)
g Ctrl-] → Preview the tag in a split without moving
:tselect {name} → Select from a list of matches
all work with with visual
maybe gd should be used for lsp go to definition

gf/gF and visual need better support
]]
