require('nvim-treesitter.configs').setup {
  ensure_installed = {
      "rust",
      "c",
      "astro",
      "lua",
      "vim",
      "javascript",
      "typescript",
      "vimdoc",
      "query",
      "yaml",
      "css",
      "json",
      "terraform",
      "sql",
      "go",
      "templ"
  },

  sync_install = false,

  auto_install = false,

  highlight = {
    enable = true,

    additional_vim_regex_highlighting = false,
  },

  ignore_install = {},

  modules = {}
}
