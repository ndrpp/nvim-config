local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
	'nvim-telescope/telescope.nvim', tag = '0.1.2',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  },

  {
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
          'vrischmann/tree-sitter-templ',
      },
      build = ':TSUpdate'
  },

  {'nvim-treesitter/playground'},

  -- COLORSCHEMES
  --{ "catppuccin/nvim", as = "catppuccin" },
  --{"rose-pine/neovim", as = "rose-pine"},
  {"rebelot/kanagawa.nvim"},
  --{"folke/tokyonight.nvim"},

  {'nvim-lua/plenary.nvim'},

  {'ThePrimeagen/harpoon'},

  {'mbbill/undotree'},

  {'tpope/vim-fugitive'},

  {                                      -- Optional
  'williamboman/mason.nvim',
  run = function()
      pcall(vim.api.nvim_command, 'MasonUpdate')
  end,
  },

--  {'williamboman/mason-lspconfig.nvim'}, -- Optional
--
--  -- Autocompletion
--  {'hrsh7th/nvim-cmp'},     -- Required
--  {'hrsh7th/cmp-nvim-lsp'}, -- Required
--  {'L3MON4D3/LuaSnip'},     -- Required
--
--  {'neovim/nvim-lspconfig'},             -- Required
--  {
--	  'VonHeikemen/lsp-zero.nvim',
--	  branch = 'v2.x',
--},

  {'nvim-tree/nvim-web-devicons'},

  {'nvim-lualine/lualine.nvim', requires = {'nvim-tree/nvim-web-devicons', opt=true}},

  {'ThePrimeagen/vim-be-good'},
  }
)
