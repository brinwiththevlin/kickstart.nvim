-- This is the updated configuration for akinsho/toggleterm.nvim
-- It now uses the 'ToggleTermOpen' autocmd for a more reliable setup.

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    -- First, set up toggleterm with your preferences
    require('toggleterm').setup {
      size = 20,
      open_mapping = [[<c-/>]],
      direction = 'float',
      float_opts = {
        border = 'curved',
      },
    }

    -- Next, create an autocmd that listens for when a terminal is fully open
    vim.api.nvim_create_autocmd('User', {
      pattern = 'ToggleTermOpen',
      callback = function(args)
        -- The terminal object is passed in args.data
        local term = args.data
        -- It's still good practice to schedule the command to avoid any race conditions
        vim.schedule(function()
          -- Check if a virtual environment is active
          if term and term.chan and vim.env.VIRTUAL_ENV then
            -- Construct the activation command for the shell
            local activate_script = vim.env.VIRTUAL_ENV .. '/bin/activate'
            local activate_cmd = 'source ' .. activate_script

            -- Send the command to the terminal to activate the venv
            vim.api.nvim_chan_send(term.chan, activate_cmd .. '\r')
          end
        end)
      end,
    })
  end,
}
