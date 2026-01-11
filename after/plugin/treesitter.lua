require("nvim-treesitter").setup({
	ensure_installed = {
		"rust",
		"c",
		"lua",
		"vim",
		"javascript",
		"typescript",
		"vimdoc",
		"query",
		"yaml",
		"css",
		"python",
		"json",
		"terraform",
		"sql",
		"go",
	},

	sync_install = false,

	auto_install = false,

	highlight = {
		enable = true,

		additional_vim_regex_highlighting = false,
	},

	ignore_install = {},

	modules = {},
})
