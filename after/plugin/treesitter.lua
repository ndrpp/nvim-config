require("nvim-treesitter.configs").setup({
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
		"elixir",
		"eex",
		"heex", --elixir related
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
