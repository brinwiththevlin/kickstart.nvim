return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    -- Use oil as the default file explorer
    default_file_explorer = true,
    -- Show useful file information
    columns = {
      'icon',
      -- "permissions",
      'size',
      'mtime',
    },
    -- Delete to trash for safety (can recover mistakes)
    delete_to_trash = true,
    -- Skip confirmation for simple operations (rename, delete single file)
    skip_confirm_for_simple_edits = true,
    -- Auto-save when selecting new entries
    prompt_save_on_select_new_entry = true,
    -- Watch filesystem for changes (useful for git operations, external edits)
    watch_for_changes = true,
    -- Enable LSP file operations (proper rename, move with LSP support)
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = false,
    },
    -- Better keymaps
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open in vertical split' },
      ['<C-h>'] = false, -- Disable to avoid conflicts with window navigation
      ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open in new tab' },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['<C-l>'] = 'actions.refresh',
      ['<BS>'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = { 'actions.cd', opts = { scope = 'tab' } },
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
    -- View options
    view_options = {
      show_hidden = false,
      -- Natural sorting for better file ordering
      natural_order = 'fast',
      case_insensitive = false,
      sort = {
        { 'type', 'asc' },
        { 'name', 'asc' },
      },
    },
    -- Better floating window config
    float = {
      padding = 2,
      max_width = 0.9,
      max_height = 0.9,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
    },
    -- Preview window settings
    preview_win = {
      update_on_cursor_moved = true,
      preview_method = 'fast_scratch',
      win_options = {},
    },
    -- Confirmation window
    confirmation = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      max_height = 0.9,
      min_height = { 5, 0.1 },
      border = 'rounded',
    },
    -- Progress window
    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      border = 'rounded',
    },
  },
  -- Keymaps for opening oil
  keys = {
    { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    {
      '<leader>-',
      function()
        require('oil').toggle_float()
      end,
      desc = 'Open oil in float',
    },
  },
  dependencies = {
    { 'echasnovski/mini.icons', opts = {} },
  },
  lazy = false,
}
