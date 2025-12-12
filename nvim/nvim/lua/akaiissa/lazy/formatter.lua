return {
  "cacharle/c_formatter_42.vim",
  config = function()
    -- No need to run `pip3 install` inside Neovim since it's installed manually
    vim.g.c_formatter_42_norminette = 1
  end,
	lazy = false
}
