-- Guard against nil registrations/unregistrations sent by some language servers.
-- Coerces nil -> {} for the Client registration APIs to avoid `ipairs` errors.
pcall(function()
  local ok, client_mod = pcall(require, 'vim.lsp.client')
  if ok and client_mod and client_mod.Client then
    local Client = client_mod.Client
    for _, name in ipairs({ '_register_dynamic', '_unregister_dynamic', '_register', '_unregister' }) do
      local orig = Client[name]
      if type(orig) == 'function' then
        Client[name] = function(self, tbl)
              -- ensure we have a table and that array entries are tables
              if type(tbl) ~= 'table' then
                tbl = {}
              else
                for i, v in ipairs(tbl) do
                  if type(v) ~= 'table' then
                    tbl[i] = {}
                  end
                end
              end
              return orig(self, tbl)
            end
      end
    end
  end
end)
-- Also wrap the client_register/unregister handlers early so params are safe
pcall(function()
  local handlers = require('vim.lsp.handlers')
  local ms = require('vim.lsp.protocol').Methods
  local orig_reg = handlers[ms.client_registerCapability]
  if type(orig_reg) == 'function' then
    handlers[ms.client_registerCapability] = function(err, params, ctx)
      params = params or {}
      params.registrations = params.registrations or {}
      if type(params.registrations) == 'table' then
        for i, v in ipairs(params.registrations) do
          if type(v) ~= 'table' then
            params.registrations[i] = {}
          end
        end
      else
        params.registrations = {}
      end
      return orig_reg(err, params, ctx)
    end
  end

  local orig_unreg = handlers[ms.client_unregisterCapability]
  if type(orig_unreg) == 'function' then
    handlers[ms.client_unregisterCapability] = function(err, params, ctx)
      params = params or {}
      params.unregistrations = params.unregistrations or params.unregisterations or {}
      if type(params.unregistrations) == 'table' then
        for i, v in ipairs(params.unregistrations) do
          if type(v) ~= 'table' then
            params.unregistrations[i] = {}
          end
        end
      else
        params.unregistrations = {}
      end
      return orig_unreg(err, params, ctx)
    end
  end
end)
