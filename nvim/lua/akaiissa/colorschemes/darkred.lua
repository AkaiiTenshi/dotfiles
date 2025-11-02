-- File: darkred.lua
local M = {}

function M.setup()
    -- Main palette
    local colors = {
        bg = "#1a0a0a",            -- very dark red/black for main background
        fg = "#d94444",            -- main text
        comment = "#b45c5c",       -- muted red
        keyword = "#ff4c4c",       -- bright red
        func = "#ff6666",          -- soft red for functions
        string = "#b23c3c",        -- deep crimson
        constant = "#e03b3b",      -- constants / numbers
        type = "#c73636",          -- types / classes
        statement = "#d92e2e",     -- control flow / statements
        operator = "#ff3333",      -- operators
        line_number_fg = "#8b2a2a", -- toned down line numbers
        gutter_bg = "#2b0d0d",     -- dark red background for gutter
        fold = "#bb4444",          -- folded text
        cursorline = "#2b0d0d",    -- cursor line
        visual = "#400909",        -- selection
    }

    -- Core highlights
    vim.api.nvim_set_hl(0, "Normal", { bg = colors.bg, fg = colors.fg })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.bg })
    vim.api.nvim_set_hl(0, "Comment", { fg = colors.comment, italic = true })
    vim.api.nvim_set_hl(0, "Keyword", { fg = colors.keyword, bold = true })
    vim.api.nvim_set_hl(0, "Function", { fg = colors.func })
    vim.api.nvim_set_hl(0, "String", { fg = colors.string })
    vim.api.nvim_set_hl(0, "Constant", { fg = colors.constant })
    vim.api.nvim_set_hl(0, "Type", { fg = colors.type })
    vim.api.nvim_set_hl(0, "Statement", { fg = colors.statement })
    vim.api.nvim_set_hl(0, "Operator", { fg = colors.operator })

    -- Gutter / line numbers with background
	vim.api.nvim_set_hl(0, "LineNr", { fg = colors.line_number_fg, bg = colors.gutter_bg })
	vim.api.nvim_set_hl(0, "Folded", { fg = colors.fold, bg = colors.gutter_bg })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff5555", bg = colors.gutter_bg, bold = true })

	vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.cursorline })
	vim.api.nvim_set_hl(0, "Visual", { bg = colors.visual })
	vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#330909" })

	-- Make netrw items red
	vim.api.nvim_set_hl(0, "netrwDir", { fg = "#d94444", bg = nil, bold = true })   -- directories
	vim.api.nvim_set_hl(0, "netrwClass", { fg = "#ff6666", bg = "#2b0d0d" })             -- file types
	vim.api.nvim_set_hl(0, "netrwExe", { fg = "#ff4c4c", bg = "#2b0d0d" })               -- executable files
	vim.api.nvim_set_hl(0, "netrwLink", { fg = "#c73636", bg = "#2b0d0d" })              -- symlinks

end

-- Load the colorscheme automatically
M.setup()
return M

