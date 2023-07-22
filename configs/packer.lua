local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute(
    '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path
  )
end

vim.cmd [[
augroup Packer
  autocmd!
  autocmd BufWritePost init.lua PackerCompile
augroup end
]]

use = require('packer').use
require('packer').startup(function()
	use 'wbthomason/packer.nvim'

	use 'vim-scripts/auto-pairs-gentle'

	use {
    		'nvim-lualine/lualine.nvim',
    		requires = {
      			'kyazdani42/nvim-web-devicons',
      			'arkav/lualine-lsp-progress',
    		},
  	}

	use 'nvim-treesitter/nvim-treesitter'

	use 'navarasu/onedark.nvim'
end)
