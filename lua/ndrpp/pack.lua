vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'mason' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('mason') end
            vim.cmd('MasonUpdate')
        end
    end
})

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
    end
})

vim.pack.add({
    'https://github.com/ellisonleao/gruvbox.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim',
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/ThePrimeagen/harpoon',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/mbbill/undotree',
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/saghen/blink.lib',
    'https://github.com/Saghen/blink.cmp'
})
