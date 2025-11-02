-- File: lua/colorscheme_blue_orchid.lua
local M = {}
M.setup = function()
  vim.opt.termguicolors = true
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end

  local colors = {
    bg       = "#1A1A2E",
    fg       = "#E0E0FF",
    blue     = "#6A5ACD",
    cyan     = "#5F9EA0",
    magenta  = "#DA70D6",
    yellow   = "#FFD700",
    gray     = "#888888",
  }

  vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.gray, italic = true })
  vim.api.nvim_set_hl(0, "String", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "Number", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "Function", { fg = colors.magenta, bold = true })
  vim.api.nvim_set_hl(0, "Keyword", { fg = colors.blue, bold = true })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2A2A44" })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#33335C" })
  vim.api.nvim_set_hl(0, "LineNr", { fg = colors.gray })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.yellow, bold = true })
end

return M

