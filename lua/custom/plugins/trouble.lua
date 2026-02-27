return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      preview_float = {
        mode = "diagnostics",
        preview = {
          type = "float",
          relative = "editor",
          border = "rounded",
          title = "Preview",
          title_pos = "center",
          position = { 0, -2 },
          size = { width = 0.3, height = 0.3 },
          zindex = 200,
        },
      },
    },
    -- Enhanced default options
    focus = false, -- Don't auto-focus trouble window
    restore = true, -- Restore last trouble window position/size
    follow = true, -- Follow cursor in trouble window
    indent_guides = true, -- Show indent guides
    max_items = 200, -- Limit items to prevent performance issues
    multiline = true, -- Show multiline messages
    pinned = false, -- Don't pin trouble window by default
    warn_no_results = false, -- Don't warn when no results
    open_no_results = false, -- Don't open when no results
    auto_close = false, -- Don't auto-close when no items
    auto_open = false, -- Don't auto-open on diagnostics
    auto_preview = true, -- Auto-preview items on cursor move
    auto_refresh = true, -- Auto-refresh when files change
    auto_jump = false, -- Don't auto-jump to item
    keys = {
      ["?"] = "help",
      r = "refresh",
      R = "toggle_refresh",
      q = "close",
      o = "jump_close",
      ["<esc>"] = "cancel",
      ["<cr>"] = "jump",
      ["<2-leftmouse>"] = "jump",
      ["<c-s>"] = "jump_split",
      ["<c-v>"] = "jump_vsplit",
      ["}"] = "next",
      ["]]"] = "next",
      ["{"] = "prev",
      ["[["] = "prev",
      dd = "delete",
      d = { action = "delete", mode = "v" },
      i = "inspect",
      p = "preview",
      P = "toggle_preview",
      zo = "fold_open",
      zO = "fold_open_recursive",
      zc = "fold_close",
      zC = "fold_close_recursive",
      za = "fold_toggle",
      zA = "fold_toggle_recursive",
      zm = "fold_more",
      zM = "fold_close_all",
      zr = "fold_reduce",
      zR = "fold_open_all",
      zx = "fold_update",
      zX = "fold_update_all",
      zn = "fold_disable",
      zN = "fold_enable",
      zi = "fold_toggle_enable",
    },
    icons = {
      indent = {
        top = "│ ",
        middle = "├╴",
        last = "└╴",
        fold_open = " ",
        fold_closed = " ",
        ws = "  ",
      },
      folder_closed = " ",
      folder_open = " ",
      kinds = {
        Array = " ",
        Boolean = "󰨙 ",
        Class = " ",
        Constant = "󰏿 ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Function = "󰊕 ",
        Interface = " ",
        Key = " ",
        Method = "󰊕 ",
        Module = " ",
        Namespace = "󰦮 ",
        Null = " ",
        Number = "󰎠 ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        String = " ",
        Struct = "󰆼 ",
        TypeParameter = " ",
        Variable = "󰀫 ",
      },
    },
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    -- Additional enhanced keymaps
    {
      "<leader>xw",
      "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.WARN<cr>",
      desc = "Warnings (Trouble)",
    },
    {
      "<leader>xe",
      "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
      desc = "Errors (Trouble)",
    },
    {
      "<leader>xt",
      "<cmd>Trouble todo toggle<cr>",
      desc = "Todo Comments (Trouble)",
    },
    {
      "<leader>xr",
      "<cmd>Trouble lsp_references toggle<cr>",
      desc = "LSP References (Trouble)",
    },
    {
      "<leader>xd",
      "<cmd>Trouble lsp_definitions toggle<cr>",
      desc = "LSP Definitions (Trouble)",
    },
    {
      "<leader>xi",
      "<cmd>Trouble lsp_implementations toggle<cr>",
      desc = "LSP Implementations (Trouble)",
    },
    {
      "<leader>xT",
      "<cmd>Trouble lsp_type_definitions toggle<cr>",
      desc = "LSP Type Definitions (Trouble)",
    },
  },
}
