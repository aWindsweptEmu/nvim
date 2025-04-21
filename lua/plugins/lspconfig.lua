return {
	"williamboman/mason.nvim",
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	"williamboman/mason-lspconfig.nvim",
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("mason").setup()

			-- install formatters
			require("mason-tool-installer").setup({
				ensure_installed = {
					"gofumpt",
					"clang-format",
					"stylua",
					"shfmt",
					"tflint",
					"hadolint",
				},
				auto_update = true,
				run_on_start = true,
			})

			-- install lsp servers
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"clangd",
					"bashls",
					"yamlls",
					"dockerls",
					"docker_compose_language_service",
				},
			})

			-- setup lsp servers
			require("lspconfig").lua_ls.setup({
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end
					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths here.
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
							-- library = vim.api.nvim_get_runtime_file("", true)
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})
			require("lspconfig").gopls.setup({
				settings = {
					gopls = {
						gofumpt = true,
					},
				},
			})
			require("lspconfig").clangd.setup({})
			require("lspconfig").bashls.setup({})
			require("lspconfig").yamlls.setup({})
			require("lspconfig").dockerls.setup({})
			require("lspconfig").docker_compose_language_service.setup({})

			-- setup lsp keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local function quickfix()
						vim.lsp.buf.code_action({
							filter = function(a)
								return a.isPreferred
							end,
							apply = true,
						})
					end

					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf, noremap = true, silent = true, desc = "" }
					local with_desc = function(options, description)
						options.desc = description
						return options
					end
					vim.keymap.set("n", "K", vim.lsp.buf.hover, with_desc(opts, "LSP hover"))
					vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, with_desc(opts, "LSP goto declaration"))
					vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, with_desc(opts, "LSP goto definition"))
					vim.keymap.set(
						"n",
						"<leader>gi",
						vim.lsp.buf.implementation,
						with_desc(opts, "LSP goto implementations")
					)
					vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, with_desc(opts, "LSP goto references"))
					vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, with_desc(opts, "LSP signature help"))
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, with_desc(opts, "LSP rename"))
					vim.keymap.set(
						"n",
						"<leader>wa",
						vim.lsp.buf.add_workspace_folder,
						with_desc(opts, "LSP add workspace folder")
					)
					vim.keymap.set(
						"n",
						"<leader>wr",
						vim.lsp.buf.remove_workspace_folder,
						with_desc(opts, "LSP remove workspace folder")
					)
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, with_desc(opts, "LSP list workspace folder"))
					vim.keymap.set(
						"n",
						"<leader>D",
						vim.lsp.buf.type_definition,
						with_desc(opts, "LSP type definition")
					)
					vim.keymap.set("n", "<leader>fm", function()
						vim.lsp.buf.format({ async = true })
					end, with_desc(opts, "LSP format"))
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						with_desc(opts, "LSP code action")
					)
					vim.keymap.set("n", "<leader>cf", function()
						vim.lsp.buf.code_action({
							filter = function(a)
								return a.isPreferred
							end,
							apply = true,
						})
					end, with_desc(opts, "LSP code action fix"))
				end,
			})
		end,
	},
}
