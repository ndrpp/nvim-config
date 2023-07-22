require('packer')

vim.o.showmode = false

vim.o.autowriteall = true

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.list = true

vim.o.breakindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 250

vim.wo.signcolumn = 'yes'

vim.o.termguicolors = true

-- Better completion
vim.o.completeopt = 'menu,menuone'

-- Remap for word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
vim.cmd [[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]

require('onedark').setup {
	style = 'darker'
}
require('onedark').load()
