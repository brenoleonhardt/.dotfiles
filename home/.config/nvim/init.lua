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
  io.stdout:write("Neovim is already running. Bailing out...\n\r")
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
	3. migrate to folke's lazydev
	4. migrate to newer which-key
	5. write custom gitlinker
	6. write custom vim-floaterm
	7. integrate zeavim better, or write custom doc reader (wrap godoc, rustup doc, man, tldr)
	8. replace telescope
	9. remove unused packages
	10. cleanup unused keybindings and unused functionalities
	11. cleanup unused functions/modules
	12. establish snippet database
]]
