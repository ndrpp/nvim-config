local lsp = require("lsp-zero")

lsp.preset("recommended")

require("mason").setup()

vim.lsp.config("elixirls", {
	cmd = { "/home/andrei/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

lsp.set_preferences({ sign_icons = {} })

vim.lsp.config("denols", {
	single_file_support = false,
	root_markers = { "deno.json" },
})
vim.lsp.config("ts_ls", {
	single_file_support = false,
	root_markers = { "package.json" },
})

vim.lsp.enable({
	"lua_ls",
	"ts_ls",
	"gopls",
	"rust_analyzer",
	"eslint",
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
	"elixirls",
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
		vim.diagnostic.jump({ count = 1, float = true })
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.jump({ count = -1, float = true })
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
