-- File: lua/colorscheme_crimson_night.lua
local M = {}
M.setup = function()
  vim.opt.termguicolors = true
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end

  local colors = {
    bg       = "#2A0D14",
    fg       = "#FFECE8",
    red      = "#FF4B5C",
    pink     = "#FF6B81",
    yellow   = "#FFD166",
    gray     = "#8C8C8C",
    orange   = "#FF8243",
  }

  vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.gray, italic = true })
  vim.api.nvim_set_hl(0, "String", { fg = colors.orange })
  vim.api.nvim_set_hl(0, "Number", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "Function", { fg = colors.red, bold = true })
  vim.api.nvim_set_hl(0, "Keyword", { fg = colors.pink, bold = true })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3B151F" })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#4D1F2A" })
end

return M

