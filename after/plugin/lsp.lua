local lsp = require("lsp-zero")

lsp.preset("recommended")

--require("lspconfig").elixirls.setup({
--	cmd = { "/home/andrei/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
--})
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"gopls",
		"rust_analyzer",
		"lua_ls",
		"eslint",
		"ts_ls",
		"html",
		"angularls",
		"cssls",
		"jsonls",
		"pyright",
		"yamlls",
		"marksman",
		"dockerls",
		"terraformls",
		"bashls",
		"ansiblels",
--		"elixirls",
	},
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

lsp.set_preferences({ sign_icons = {} })
lsp.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "cmp_mappings" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
	--completion = {
	--	autocomplete = false,
	--},
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>vrr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end)

lsp.setup()
