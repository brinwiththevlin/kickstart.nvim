-- File: lua/plugins/project.lua
-- Plugin specification for project.nvim (project management)
return {
  'ahmedkhalf/project.nvim',
  event = 'VeryLazy', -- load on first Telescope or Project command
  config = function()
    require('project_nvim').setup {
      -- Manual mode doesn't automatically change your root directory, use the commands instead
      manual_mode = false,
      -- Methods of detecting the root directory: by pattern or lsp
      detection_methods = { 'pattern', 'lsp' },
      -- Patterns to identify project root
      patterns = { '.git', 'Makefile', 'package.json', 'pyproject.toml' },
      -- Show hidden files in Telescope picker
      show_hidden = true,
      -- Silent chdir?
      silent_chdir = true,
      -- Callback executed when root changes
      on_config_done = nil,
    }
    -- Optional: load telescope extension
    pcall(require('telescope').load_extension, 'projects')
  end,
}
