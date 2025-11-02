-- File: lua/colorscheme_midnight_orchid.lua
local M = {}
M.setup = function()
  vim.opt.termguicolors = true
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end

  local colors = {
    bg       = "#1C1B33",
    fg       = "#EDEDED",
    dark_orchid = "#9932CC",
    purple   = "#8A2BE2",
    blue     = "#4169E1",
    cyan     = "#20B2AA",
    gray     = "#777777",
    yellow   = "#FFD700",
  }

  vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.gray, italic = true })
  vim.api.nvim_set_hl(0, "String", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "Number", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "Function", { fg = colors.dark_orchid, bold = true })
  vim.api.nvim_set_hl(0, "Keyword", { fg = colors.purple, bold = true })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2A2944" })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#3B3A60" })
end

return M

