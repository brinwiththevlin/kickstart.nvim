return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    -- Guard: some language servers may send nil registrations/unregistrations
    -- which causes `ipairs` errors in Neovim's client. Wrap the Client
    -- methods to coerce nil -> {} to avoid crashes without changing runtime.
    pcall(function()
      local ok, client_mod = pcall(require, 'vim.lsp.client')
      if ok and client_mod and client_mod.Client then
        local Client = client_mod.Client
        for _, name in ipairs({ '_register_dynamic', '_unregister_dynamic', '_register', '_unregister' }) do
          local orig = Client[name]
          if type(orig) == 'function' then
            Client[name] = function(self, tbl)
              tbl = tbl or {}
              return orig(self, tbl)
            end
          end
        end
      end
    end)

    -- Wrap LSP runtime handlers to defensively coerce nil params
    pcall(function()
      local handlers = require('vim.lsp.handlers')
      local ms = require('vim.lsp.protocol').Methods
      local orig_reg = handlers[ms.client_registerCapability]
      if type(orig_reg) == 'function' then
        handlers[ms.client_registerCapability] = function(err, params, ctx)
          params = params or {}
          params.registrations = params.registrations or {}
          return orig_reg(err, params, ctx)
        end
      end

      local orig_unreg = handlers[ms.client_unregisterCapability]
      if type(orig_unreg) == 'function' then
        handlers[ms.client_unregisterCapability] = function(err, params, ctx)
          params = params or {}
          -- accept either correct or misspelled field name
          params.unregistrations = params.unregistrations or params.unregisterations or {}
          return orig_unreg(err, params, ctx)
        end
      end
    end)
    -- Fix position_encoding warnings (from config 2)
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.handlers['textDocument/publishDiagnostics'], {
      position_encoding = 'utf-16',
    })

    -- LspAttach autocmd for keymaps (from config 1)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Keymaps from config 1
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Helper function for version compatibility
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- Document highlight
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Inlay hints toggle
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end

        -- Custom hover/signature help cleanup (from config 2, if using pretty_hover)
        -- Uncomment if you have pretty_hover plugin
        -- local pretty_hover = require("pretty_hover")
        -- local html_entities = {
        --    ["&nbsp;"] = " ",
        --    ["&lt;"] = "<",
        --    ["&gt;"] = ">",
        --    ["&amp;"] = "&",
        -- }
        -- local function clean_entities(lines)
        --    for i, line in ipairs(lines) do
        --       for entity, replacement in pairs(html_entities) do
        --          line = line:gsub(entity, replacement)
        --       end
        --       line = line:gsub("\\_", "_")
        --       lines[i] = line
        --    end
        --    return lines
        -- end
      end,
    })

    -- Diagnostic Config (from config 1, enhanced with config 2's rounded borders)
    vim.diagnostic.config {
      severity_sort = true,
      float = {
        border = 'rounded',
        source = 'if_many',
        focusable = false,
        style = 'minimal',
        header = '',
        prefix = '',
      },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          return diagnostic.message
        end,
      },
    }

    -- Capabilities (merged from both configs)
    local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())
    capabilities.general.positionEncodings = { 'utf-16' }

    -- Server configurations
    local servers = {
      clangd = {
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--suggest-missing-includes' },
        settings = {
          clangd = {
            completion = { detailedLabel = true },
            diagnostics = {
              severity = { unused_variable = 'warning' },
            },
          },
        },
      },
      gopls = {},
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              autoImportCompletion = true,
              autoSearchPaths = true,
              diagnosticMode = 'openFilesOnly',
              useLibraryCodeForTypes = true,
              typeCheckingMode = 'recommended',
              exclude = { '**/.venv', '**/__pycache__', '**/**cache', '**/build', '**/dist', '**/.git', '**/basedpyright', '**/envs' },
              diagnosticSeverityOverrides = {
                reportUnusedVariable = 'true',
                reportUnusedFunction = 'true',
                reportExplicitAny = 'none',
                reportAny = 'none',
                reportGeneralTypeIssue = 'true',
                reportMissingTypeStubs = 'none',
                strictDictionaryInference = 'none',
                strictListInference = 'none',
                strictSetInference = 'none',
              },
            },
          },
        },
      },
      rust_analyzer = {
        -- ##### THIS IS THE FIX #####
        -- Tell lspconfig to find the root by looking for .git or a Cargo.toml with [workspace]
        root_dir = require('lspconfig.util').root_pattern('.git', 'Cargo.toml'),

        settings = {
          ['rust-analyzer'] = {
            checkOnSave = {
              command = 'clippy',
              args = { '--workspace', '--all-targets' },
            },
          },
        },
      },
      ts_ls = {},
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'Lua 5.1' },
            completion = { callSnippet = 'Replace' },
            diagnostics = {
              globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
            },
          },
        },
      },
      zls = {
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find({ '.git', 'build.zig', 'zls.json' }, { upward = true, path = fname })[1])
        end,
        settings = {
          zls = {
            enable_inlay_hints = true,
            enable_snippets = true,
            warn_style = true,
          },
        },
      },
      ruff = {},
    }

    -- Mason setup
    -- NOTE: Some tools may need manual installation if not available via Mason:
    -- - cppcheck: sudo apt install cppcheck (Ubuntu/Debian) or brew install cppcheck (macOS)
    -- - chktex: sudo apt install chktex (Ubuntu/Debian) or brew install chktex (macOS)
    -- - latexindent: Usually comes with TeX distributions (texlive-extra-utils)
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      -- Lua formatters
      'stylua',
      -- Python formatters and linters
      'black',
      'isort',
      'ruff',
      -- 'ruff-lsp', -- May not be available via Mason, install manually if needed
      
      -- C/C++ formatters and linters
      'clang-format',
      'cpplint',
      -- 'cppcheck', -- May need manual installation
      -- Go formatters and linters
      'gofumpt',
      'goimports',
      'golangci-lint',
      -- LaTeX formatters and linters
      -- 'latexindent', -- Usually comes with TeX distribution
      -- 'chktex', -- May need manual installation
      -- Markdown linters
      'markdownlint',
      -- DAP tools
      'delve',
      'debugpy',
      'cpptools',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

          -- Custom hover handlers removed to prevent conflicts with noice.nvim
          -- noice.nvim will handle hover styling with borders

          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    -- nvim-cmp setup (from config 2)
    local cmp = require 'cmp'
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete(),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      }),
    }
  end,
}
