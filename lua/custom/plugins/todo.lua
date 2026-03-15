return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    signs = false, -- This disables the icons in the sign column (gutter)
    keywords = {
      -- Note: If you want a block, having a blank icon is fine,
      -- but usually, a space ' ' helps padding.
      TODO = { icon = ' ', color = 'info' },
    },
    highlight = {
      before = '', -- "fg", "bg", or empty
      keyword = 'bg', -- CHANGED: "bg" creates the block effect
      after = 'fg', -- "fg", "bg", or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlighting
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = {}, -- list of file types to exclude highlighting
    },
  },
  config = function(_, opts)
    require('todo-comments').setup(opts)

    -- Keymaps
    vim.keymap.set('n', ']t', function()
      require('todo-comments').jump_next()
    end, { desc = 'Next todo comment' })

    vim.keymap.set('n', '[t', function()
      require('todo-comments').jump_prev()
    end, { desc = 'Previous todo comment' })
  end,
}
