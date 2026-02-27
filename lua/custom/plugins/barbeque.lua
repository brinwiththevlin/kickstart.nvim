-- File: lua/plugins/barbecue.lua
-- Plugin specification for barbecue.nvim (sticky winbar showing file path + code context)
return {
    'utilyre/barbecue.nvim',
    version = '*',
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- optional, for file icons in winbar
        'SmiteshP/nvim-navic',         -- provides code context (function names)
    },
    event = { 'WinScrolled', 'BufWinEnter', 'CursorHold', 'CursorMoved' },
    config = function()
        -- Setup nvim-navic
        require('nvim-navic').setup {
            highlight = true,
            separator = '  ', -- symbol separator between path and context
        }

        -- Setup barbecue with basic configuration
        require('barbecue').setup {
            attach_navic = true, -- have barbecue automatically attach navic
            theme = 'auto',      -- use colorscheme derived theme
        }

        -- Auto-update winbar on navigation events
        local bbq_updater = vim.api.nvim_create_augroup('barbecue_updater', { clear = true })
        vim.api.nvim_create_autocmd({ 'WinScrolled', 'BufWinEnter', 'CursorHold', 'CursorMoved' }, {
            group = bbq_updater,
            callback = function()
                require('barbecue.ui').update()
            end,
        })
    end,
}
