-- Path to store the last chosen colorscheme
local colorscheme_file = vim.fn.stdpath 'data' .. '/last_colorscheme'

-- Load saved colorscheme on startup
local ok, _ = pcall(function()
  local f = io.open(colorscheme_file, 'r')
  if f then
    local saved = f:read '*l'
    f:close()
    if saved and saved ~= '' then
      vim.cmd.colorscheme(saved)
    end
  end
end)

-- Save colorscheme whenever it changes
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local f = io.open(colorscheme_file, 'w')
    if f then
      f:write(vim.g.colors_name)
      f:close()
    end
  end,
})
