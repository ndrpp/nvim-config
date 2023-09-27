require('scipio24.remap')
require('scipio24.set')
require('scipio24.lazy')

vim.cmd.colorscheme "catppuccin"

require('lualine').setup {
    options = { theme = 'auto' }
}
