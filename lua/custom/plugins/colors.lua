return {
  -- Erik Backman's brightburn color scheme
  {
    'erikbackman/brightburn.vim',
  },

  -- Kanagawa color scheme
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup {
        -- transparent = true,
        theme = 'dark',
      }
      -- vim.cmd [[colors kanagawa-dragon]]
    end,
  },

  -- Tokyo Night color scheme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    config = function()
      require('tokyonight').setup {
        style = 'storm',
        -- transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = 'dark',
          floats = 'dark',
        },
      }
    end,
  },

  -- Rose Pine color scheme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        -- disable_background = true,
        styles = {
          italic = false,
        },
      }
      vim.cmd [[colors rose-pine]]
    end,
  },

  -- Gruvbox color scheme
  {
    'ellisonleao/gruvbox.nvim',
    config = function()
      require('gruvbox').setup {
        contrast = 'soft', -- Can be "hard", "soft", or "medium"
        -- transparent_mode = true,
      }
    end,
  },

  -- Dracula color scheme
  {
    'Mofiqul/dracula.nvim',
    config = function()
      require('dracula').setup {
        -- transparent_bg = true,
        italic_comment = false,
      }
    end,
  },

  -- OneDark color scheme
  {
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup {
        style = 'darker', -- Can be "dark", "darker", "cool", "deep", "warm", "warmer"
        -- transparent = true,
      }
    end,
  },

  -- Catppuccin color scheme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- Can be "latte", "frappe", "macchiato", or "mocha"
        -- transparent_background = true,
        styles = {
          comments = { 'italic' },
          keywords = { 'bold' },
        },
      }
      -- vim.cmd([[colorscheme catppuccin]])
    end,
  },

  -- Nord color scheme
  {
    'shaunsingh/nord.nvim',
    config = function()
      -- vim.g.nord_disable_background = true
      vim.g.nord_italic = false
      -- vim.cmd([[colorscheme nord]])
    end,
  },
}
