-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
-- See the kickstart.nvim README for more information

return {
  {
    'kdheepak/lazygit.nvim',
    cmd = 'LazyGit',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<CR>', desc = 'Open LazyGit' },
    },
    config = function()
      -- Optional: customize lazygit window
      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_corner_chars = { '╭', '╮', '╰', '╯' } -- customize corner characters
      vim.g.lazygit_use_neovim_remote = 0 -- fallback to 0 if neovim-remote is not installed
    end,
  },
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'git status' })

      local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup('ThePrimeagen_Fugitive', {})

      local autocmd = vim.api.nvim_create_autocmd
      autocmd('BufWinEnter', {
        group = ThePrimeagen_Fugitive,
        pattern = '*',
        callback = function()
          if vim.bo.ft ~= 'fugitive' then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set('n', '<leader>p', function()
            vim.cmd.Git 'push'
          end, vim.tbl_extend('force', opts, { desc = 'git push' }))

          -- rebase always
          vim.keymap.set('n', '<leader>P', function()
            vim.cmd.Git { 'pull', '--rebase' }
          end, vim.tbl_extend('force', opts, { desc = 'git pull --rebase' }))

          -- NOTE: It allows me to easily set the branch i am pushing and any tracking
          -- needed if i did not set the branch up correctly
          vim.keymap.set('n', '<leader>t', ':Git push -u origin ', vim.tbl_extend('force', opts, { desc = 'git push -u origin' }))
        end,
      })

      vim.keymap.set('n', 'gu', '<cmd>diffget //2<CR>', { desc = 'get from left' })
      vim.keymap.set('n', 'gh', '<cmd>diffget //3<CR>', { desc = 'get from right' })
    end,
  },
  {
    'mbbill/undotree',
    lazy = false, -- Load the plugin immediately
    config = function()
      -- Optional: Set up a keybinding to toggle UndoTree
      vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'ray-x/lsp_signature.nvim',
    lazy = false, -- Load the plugin immediately for signature help
    config = function()
      require('lsp_signature').setup {
        bind = true,
        hint_enable = true,
        floating_window = false, -- Disabled to prevent conflicts with noice.nvim
        transparency = 20,
        max_width = 80,
      }
    end,
  },
  {
    'lukas-reineke/virt-column.nvim',
    lazy = false, -- Load the plugin immediately
    config = function()
      require('virt-column').setup {
        char = '│', -- Use a skinny line character
        virtcolumn = '100', -- Specify the column number(s) where you want the line
      }
    end,
  },
  -- Rainbow brackets via treesitter
  {
    'p00f/nvim-ts-rainbow',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  -- Rainbow indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('indent_blankline').setup {
        char = '│',
        buftype_exclude = { 'terminal', 'help' },
        show_trailing_blankline_indent = false,
        show_current_context = false,
        filetype_exclude = { 'help', 'startify', 'dashboard', 'packer', 'neogitstatus' },
        -- Use space-separated highlight groups to create a rainbow effect
        char_highlight_list = {
          'IndentBlanklineChar1',
          'IndentBlanklineChar2',
          'IndentBlanklineChar3',
          'IndentBlanklineChar4',
          'IndentBlanklineChar5',
          'IndentBlanklineChar6',
        },
      }
    end,
  },
}
