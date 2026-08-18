require("mason").setup({
    firewall = {
        enabled = true
    }
})

vim.lsp.enable({
    "astro-language-server",
    "bash-language-server",
    "biome",
    "clangd",
    "eslint",
    "gopls",
    "html-lsp",
    "intelephense",
    "java-language-server",
    "lua-language-server",
    "pylyzer",
    "rust-analyzer",
    "stylelint",
    "svelte-language-server",
    "typescript-language-server",
    "vim-language-server",
    "yaml-language-server"
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event) 
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client then
        client.server_capabilities.semanticTokensProvider = nil
      end

      local opts = { buffer = event.buf, remap = false }

      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
      vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
      vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
      vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
      vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
      vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end,
})
