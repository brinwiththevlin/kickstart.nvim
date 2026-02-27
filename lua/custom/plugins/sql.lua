return {
  -- Syntax highlighting and indentation
  { 'lifepillar/pgsql.vim', ft = 'sql' },

  -- Optional: SQL query execution (can connect to DB inside Neovim)
  {
    'tpope/vim-dadbod',
    cmd = { 'DB', 'DBUI' },
    keys = {
      { '<leader>Du', '<cmd>DBUI<CR>', desc = 'Open Dadbod UI' },
      { '<leader>Dr', '<cmd>DB<CR>', desc = 'Run SQL Query' },
    },
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'tpope/vim-dadbod' },
    cmd = { 'DBUI' },
  },

  -- Optional: Align SQL columns (nice-to-have)
  {
    'junegunn/vim-easy-align',
    ft = 'sql',
    keys = {
      { 'ga=', '<Plug>(EasyAlign)', mode = { 'n', 'x' }, desc = 'Easy Align SQL' },
    },
  },
}
