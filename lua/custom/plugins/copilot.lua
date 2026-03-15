return {
  -- GitHub Copilot - AI code completion
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
          },
          layout = {
            position = 'bottom', -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = '<S-Tab>',
            accept_word = false,
            accept_line = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ['.'] = false,
        },
        copilot_node_command = 'node', -- Node.js version used by Copilot
      }
    end,
  },

  -- Copilot Chat - Assistant panel integration
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      'zbirenbaum/copilot.lua',
      'nvim-lua/plenary.nvim',
    },
    opts = {
      debug = true, -- Enable debugging to see errors
      -- Using default OpenAI model
      model = 'claude-sonnet-4.5', -- Default model
      show_help = true, -- Show help text for CopilotChatHelp
      prompts = {
        Explain = {
          prompt = 'Explain how the following code works:\n```$filetype\n$selection\n```',
        },
        Review = {
          prompt = 'Review the following code and provide suggestions for improvement:\n```$filetype\n$selection\n```',
        },
        Tests = {
          prompt = 'Generate unit tests for the following code:\n```$filetype\n$selection\n```',
        },
        Refactor = {
          prompt = 'Refactor the following code to improve performance and readability:\n```$filetype\n$selection\n```',
        },
      },
    },
    keys = {
      { '<leader>cc', '<cmd>CopilotChat<CR>', desc = 'CopilotChat - Open' },
      { '<leader>ce', '<cmd>CopilotChatExplain<CR>', desc = 'CopilotChat - Explain code', mode = { 'n', 'v' } },
      { '<leader>cr', '<cmd>CopilotChatReview<CR>', desc = 'CopilotChat - Review code', mode = { 'n', 'v' } },
      { '<leader>ct', '<cmd>CopilotChatTests<CR>', desc = 'CopilotChat - Generate tests', mode = { 'n', 'v' } },
      { '<leader>cf', '<cmd>CopilotChatRefactor<CR>', desc = 'CopilotChat - Refactor code', mode = { 'n', 'v' } },
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)

      -- Add CopilotChat group to which-key
      local ok, wk = pcall(require, 'which-key')
      if ok then
        wk.add {
          { '<leader>c', group = 'Copilot/[C]ode' },
        }
      end
    end,
  },
}
