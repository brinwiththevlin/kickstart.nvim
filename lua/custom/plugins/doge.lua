return {
  {
    'kkoomen/vim-doge',
    build = ':call doge#install()', -- This installs necessary generators for vim-doge
    config = function()
      -- DoGe specific configurations
      vim.g.doge_doc_standard_python = 'google' -- Example: Use Google docstrings for Python
    end,
  },
}
