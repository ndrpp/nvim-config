require("ndrpp.remap")
require("ndrpp.set")
require("ndrpp.lazy")

vim.cmd.colorscheme "catppuccin"
--vim.cmd.colorscheme "rose-pine"
--vim.cmd.colorscheme("kanagawa")
--require("gruvbox").setup({
--    contrast = "hard"
--})
--vim.cmd.colorscheme("gruvbox")

require("lualine").setup({
	options = { theme = "auto" },
})
