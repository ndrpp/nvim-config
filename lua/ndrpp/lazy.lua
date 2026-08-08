local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" } },
    },

	{
		"nvim-treesitter/nvim-treesitter",
        lazy = false,
		build = ":TSUpdate",
	},

	-- COLORSCHEMES
	--{ "catppuccin/nvim", as = "catppuccin" },
	--{"rose-pine/neovim", as = "rose-pine"},
	--{ "rebelot/kanagawa.nvim" },
    { "ellisonleao/gruvbox.nvim" },

	{ "nvim-lua/plenary.nvim" },

	{ "ThePrimeagen/harpoon" },

	{ "mbbill/undotree" },

	{ "tpope/vim-fugitive" },

	{ 
		"williamboman/mason.nvim",
		run = function()
			pcall(vim.api.nvim_command, "MasonUpdate")
		end,
	},

	{ "nvim-tree/nvim-web-devicons" },

	{ "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons", opt = true } },

	{ "ThePrimeagen/vim-be-good" },
})
