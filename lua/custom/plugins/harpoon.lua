return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
        local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return vim.loop.cwd()
        end,
      },
    }
    -- Basic telescope configuration
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      local conf = require('telescope.config').values
      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })

    -- Keymaps
    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = 'Add file to Harpoon' })
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle Harpoon quick menu' })

            local conf = require('telescope.config').values
            require('telescope.pickers')
                .new({}, {
                    prompt_title = 'Harpoon',
                    finder = require('telescope.finders').new_table {
                        results = file_paths,
                    },
                    previewer = conf.file_previewer {},
                    sorter = conf.generic_sorter {},
                })
                :find()
        end

        -- Keymaps
        vim.keymap.set('n', '<leader>a', function()
            local current_file = vim.api.nvim_buf_get_name(0)
            -- Don't add file manager buffers to harpoon
            if vim.b.is_file_manager or current_file == "" or current_file:match("^%w+://") then
                vim.notify("Cannot harpoon this buffer type", vim.log.levels.WARN)
                return
            end
            harpoon:list():add()
            vim.notify("Added to harpoon: " .. vim.fn.fnamemodify(current_file, ":t"), vim.log.levels.INFO)
        end, { desc = 'Add file to Harpoon' })
        vim.keymap.set('n', '<C-e>', function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = 'Toggle Harpoon quick menu' })

        -- Telescope integration
        vim.keymap.set('n', '<leader>he', function()
            toggle_telescope(harpoon:list())
        end, { desc = 'Open Harpoon in Telescope' })

        -- Quick file navigation
        vim.keymap.set('n', '<C-h>', function()
            harpoon:list():select(1)
        end, { desc = 'Harpoon file 1' })
        vim.keymap.set('n', '<C-j>', function()
            harpoon:list():select(2)
        end, { desc = 'Harpoon file 2' })
        vim.keymap.set('n', '<C-k>', function()
            harpoon:list():select(3)
        end, { desc = 'Harpoon file 3' })
        vim.keymap.set('n', '<C-l>', function()
            harpoon:list():select(4)
        end, { desc = 'Harpoon file 4' })

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set('n', '<C-S-P>', function()
            harpoon:list():prev()
        end, { desc = 'Prev Harpoon file' })
        vim.keymap.set('n', '<C-S-N>', function()
            harpoon:list():next()
        end, { desc = 'Next Harpoon file' })
    end,
}
