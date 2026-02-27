return {
  'kylechui/nvim-surround',
  version = '*', -- Use for stability; omit to use `main` branch for the latest updates
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup {}
  end,
}
