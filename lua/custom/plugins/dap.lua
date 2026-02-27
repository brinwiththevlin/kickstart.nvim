return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    -- ... your existing keys ...
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Setup Mason-Nvim-Dap first
    require('mason-nvim-dap').setup {
      automatic_installation = true,

      -- Handlers set up adapters automatically so you don't have to manualy define them
      handlers = {
        function(config)
          -- strict "default" handler to avoid double-setup
          require('mason-nvim-dap').default_setup(config)
        end,

        -- Customizing PHP, Python, or others if needed
        python = function(config)
          -- Ignore python here, we handle it with dap-python below
        end,
      },

      -- Ensure these are installed
      ensure_installed = {
        'codelldb', -- Rust/C++
        'netcoredbg', -- C#
        'debugpy', -- Python
        'delve', -- Go
      },
    }

    dapui.setup()

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    dap.set_log_level 'INFO' -- 'TRACE' is very noisy, only use if debugging DAP itself

    -- GO SETUP
    require('dap-go').setup()

    -- PYTHON SETUP
    local function get_python_path()
      local venv = os.getenv('VIRTUAL_ENV')
      if venv and vim.fn.executable(venv .. '/bin/python') == 1 then
        return venv .. '/bin/python'
      end
      local mason_py = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
      return mason_py
    end
    require('dap-python').setup(get_python_path())

    -- C# SETUP (Manual config often required for netcoredbg arguments)
    dap.adapters.coreclr = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/bin/netcoredbg',
      args = { '--interpreter=vscode' },
    }
    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          -- Helper to find the dll in the standard .NET output path
          return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net8.0/', 'file')
        end,
      },
    }

    -- RUST / C++ Setup
    -- Since we used the Mason default handler above, 'codelldb' is already set up as an adapter.
    -- We just need to define the configuration (how to launch it).

    dap.configurations.rust = {
      {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    -- Reuse codelldb for C++ (it's often better than cpptools on Linux)
    dap.configurations.cpp = dap.configurations.rust
  end,
}
