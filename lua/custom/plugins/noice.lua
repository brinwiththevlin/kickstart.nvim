-- File: lua/plugins/noice.lua
-- Plugin specification for noice.nvim (enhanced UI for messages, cmdline, and popup menus)
return {
    'folke/noice.nvim',
    event = 'VimEnter',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'stevearc/dressing.nvim',
        'rcarriga/nvim-notify',
    },
    opts = {
        -- Configure how LSP messages are handled
        lsp = {
            override = {
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
                ['cmp.entry.get_documentation'] = true,
            },
            hover = { enabled = true }, -- enable hover docs
            signature = { enabled = true }, -- disable signature help
        },

        -- Sensible presets for a good user experience
        presets = {
            command_palette = true, -- position command palette at the top
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false,     -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true,  -- add a border to lsp doc hovers
        },

        -- Route messages through the noice UI
        messages = {
            enabled = true,
            view = 'mini',
            view_error = 'notify',
            view_warn = 'notify',
            view_history = 'messages',
            view_search = 'virtualtext',
        },

        -- Configure the command-line UI with more detailed formatting
        cmdline = {
            enabled = true,
            view = 'cmdline_popup',
            format = {
                cmdline = { pattern = '^:', icon = '', lang = 'vim' },
                search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
                search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
                filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
                lsp_rename = { kind = 'rename', icon = '󰑕', lang = 'vim' },
                help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
            },
        },

        -- Use nui for the popup menu (e.g., for completion)
        popupmenu = {
            enabled = true,
            backend = 'nui',
        },
    },
    config = function(_, opts)
        -- It's important that dressing is set up BEFORE noice
        require('dressing').setup()
        require('noice').setup(opts)

        -- Safely override vim.notify to avoid conflicts with lazy.nvim
        local noice_notify = require('noice').api.notify
        local original_notify = vim.notify

        vim.notify = function(msg, level, opts_notify)
            -- If noice is available and properly initialized, use it
            if noice_notify and type(noice_notify) == 'function' then
                local success, result = pcall(noice_notify, msg, level, opts_notify)
                if success then
                    return result
                end
            end
            -- Fallback to original notify if noice fails
            return original_notify(msg, level, opts_notify)
        end
    end,
}
