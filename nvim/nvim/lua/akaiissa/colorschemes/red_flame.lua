-- File: lua/colorscheme_red_flame.lua
local M = {}

M.setup = function()
  vim.opt.termguicolors = true
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end

  local colors = {
    bg       = "#1C0F13", -- dark reddish background
    fg       = "#F8F8F2",
    red      = "#FF5555",
    orange   = "#FF8C42",
    yellow   = "#FFD93D",
    pink     = "#FF6F91",
    gray     = "#777777",
  }

  vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.gray, italic = true })
  vim.api.nvim_set_hl(0, "String", { fg = colors.orange })
  vim.api.nvim_set_hl(0, "Number", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "Function", { fg = colors.red, bold = true })
  vim.api.nvim_set_hl(0, "Keyword", { fg = colors.pink, bold = true })
  vim.api.nvim_set_hl(0, "Statement", { fg = colors.red })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2A151B" })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#3C1F27" })
  vim.api.nvim_set_hl(0, "LineNr", { fg = colors.gray })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.yellow, bold = true })
end

return M

