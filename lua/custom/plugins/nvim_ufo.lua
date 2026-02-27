-- Correct config for nvim-ufo
return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    -- Make sure you require the plugin at the top!
    local ufo = require 'ufo'
    ufo.setup()

    -- Your line 16 is probably one of these keymaps,
    -- but you are passing 'nil' instead of 'ufo.openAllFolds'
    vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
  end,
}
