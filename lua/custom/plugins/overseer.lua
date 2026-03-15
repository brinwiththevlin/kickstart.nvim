return {
  'stevearc/overseer.nvim',
  config = function()
    require('overseer').setup {
      task_list = {
        direction = 'bottom',
        min_height = 15,
        max_height = 20,
        default_detail = 1,
      },
    }

    -- Keymaps
    vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<cr>', { desc = 'Overseer Run' })
    vim.keymap.set('n', '<leader>ot', '<cmd>OverseerToggle<cr>', { desc = 'Overseer Toggle' })
    vim.keymap.set('n', '<leader>oo', '<cmd>OverseerOpen<cr>', { desc = 'Overseer Open' })
    vim.keymap.set('n', '<leader>oq', '<cmd>OverseerQuickAction<cr>', { desc = 'Overseer Quick Action' })
  end,
}
