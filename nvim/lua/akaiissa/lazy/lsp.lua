return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

				local builtin = require("telescope.builtin")

				vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
				vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = bufnr })
				vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr })
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
				vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
				vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = bufnr })
				vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })
				vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = bufnr })
			end,
		})
		require("conform").setup({
			formatters_by_ft = {
			}
		})
		local cmp = require('cmp')
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		cmp_lsp.default_capabilities())

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"pyright",
				"lua_ls"
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup {
						capabilities = capabilities
					}
				end,
				clangd = function()
					require("lspconfig").clangd.setup({
						capabilities = capabilities,
						root_dir = require("lspconfig").util.root_pattern(".git", "Makefile", "includes", "include", "compile_commands.json", ".clangd"),
						cmd = { 
							"clangd", "--background-index", "--clang-tidy", "--header-insertion=never",
						},
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup {
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.1" },
								diagnostics = {
									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
								}
							}
						}
					}
				end,

				pyright = function()
					require("lspconfig").pyright.setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "basic",
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
									diagnosticMode = "workspace",
								},
							},
						},
					})
				end,}
			})

			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local luasnip = require('luasnip')

			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					["<C-s>"] = cmp.mapping.complete(),
					["<C-l>"] = cmp.mapping(function(fallback)
						if require('luasnip').expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, {'i', 's'}),
					["<C-h>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {'i', 's'}),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' }, -- For luasnip users.
				}, {
					{ name = 'buffer' },
				})
			})

			vim.diagnostic.config({
				-- update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end
	}
