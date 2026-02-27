-- -- GitHub Copilot and Copilot Assistant Panel integration
-- -- This file adds GitHub Copilot for code completion and the assistant panel
--
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
            refresh = '<leader>cp',
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
    -- FIX #1: Make this plugin lazy-load along with the main copilot plugin
    -- to prevent a race condition on startup.
    cmd = { 'CopilotChat', 'CopilotChatExplain', 'CopilotChatReview', 'CopilotChatTests', 'CopilotChatRefactor' },
    event = 'InsertEnter',
    keys = {
      { '<leader>cc', '<cmd>CopilotChat<CR>', desc = 'CopilotChat - Open' },
      { '<leader>ce', '<cmd>CopilotChatExplain<CR>', desc = 'CopilotChat - Explain code', mode = { 'n', 'v' } },
      { '<leader>cr', '<cmd>CopilotChatReview<CR>', desc = 'CopilotChat - Review code', mode = { 'n', 'v' } },
      { '<leader>ct', '<cmd>CopilotChatTests<CR>', desc = 'CopilotChat - Generate tests', mode = { 'n', 'v' } },
      { '<leader>cf', '<cmd>CopilotChatRefactor<CR>', desc = 'CopilotChat - Refactor code', mode = { 'n', 'v' } },
    },
    -- FIX #2: Removed the redundant `opts` table.
    -- All setup is now handled correctly in the `config` function.
    config = function()
      -- Define your options as a local table
      local opts = {
        debug = true, -- Enable debugging to see errors
        -- FIX #3: FATAL ERROR. Removed 'model = "claude-3.7-sonnet"'
        -- This plugin is for GitHub Copilot (GPT models), not Claude.
        -- Removing this line lets it use the correct Copilot default.
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
      }

      -- Pass your options table to the setup function
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
