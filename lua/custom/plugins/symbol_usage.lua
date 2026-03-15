-- plugins/symbol-usage.lua
return {
  'Wansmer/symbol-usage.nvim',
  event = 'BufReadPre',
  config = function()
    local function h(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end

    -- Highlight groups for the bubble style
    vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
    vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
    vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
    vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
    vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

    local function text_format(symbol)
      local res = {}
      local round_start = { '', 'SymbolUsageRounding' }
      local round_end = { '', 'SymbolUsageRounding' }

      local stacked = symbol.stacked_count > 0 and ('+%s'):format(symbol.stacked_count) or ''

      if symbol.references then
        local usage = symbol.references <= 1 and 'usage' or 'usages'
        local num = symbol.references == 0 and 'no' or symbol.references
        table.insert(res, round_start)
        table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
        table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
        table.insert(res, round_end)
      end

      if symbol.definition then
        if #res > 0 then
          table.insert(res, { ' ', 'NonText' })
        end
        table.insert(res, round_start)
        table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
        table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
        table.insert(res, round_end)
      end

      if symbol.implementation then
        if #res > 0 then
          table.insert(res, { ' ', 'NonText' })
        end
        table.insert(res, round_start)
        table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
        table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
        table.insert(res, round_end)
      end

      if stacked ~= '' then
        if #res > 0 then
          table.insert(res, { ' ', 'NonText' })
        end
        table.insert(res, round_start)
        table.insert(res, { ' ', 'SymbolUsageImpl' })
        table.insert(res, { stacked, 'SymbolUsageContent' })
        table.insert(res, round_end)
      end

      return res
    end

    local SymbolKind = vim.lsp.protocol.SymbolKind

    require('symbol-usage').setup {
      text_format = text_format,
      -- Track functions, methods, and classes by default
      kinds = {
        SymbolKind.Function,
        SymbolKind.Method,
        SymbolKind.Class,
      },
      references = { enabled = true, include_declaration = false },
      definition = { enabled = false },
      implementation = { enabled = false },
      vt_position = 'above', -- 'above' | 'end_of_line' | 'textwidth' | 'signcolumn'
      request_pending_text = '  loading...',
      hl = { link = 'Comment' },
      -- Disable for filetypes where it's noisy
      disable = {
        filetypes = { 'dockerfile', 'markdown', 'help' },
        lsp = {},
        cond = {},
      },
    }
  end,
}
