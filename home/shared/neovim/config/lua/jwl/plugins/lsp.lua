return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})
			-- NixOS 26.05 ships Roslyn 5.7. The pinned lspconfig defaults to
			-- --autoLoadProjects (5.8+), so explicitly open the solution/project.
			vim.lsp.config("roslyn_ls", {
				cmd = { "Microsoft.CodeAnalysis.LanguageServer", "--stdio" },
				capabilities = { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } },
				before_init = function() end,
				on_init = function(client)
					local solutions, projects = {}, {}
					for name, kind in vim.fs.dir(client.config.root_dir) do
						if kind == "file" then
							local uri = vim.uri_from_fname(vim.fs.joinpath(client.config.root_dir, name))
							if name:match("%.slnx?$") then
								table.insert(solutions, uri)
							elseif name:match("%.csproj$") then
								table.insert(projects, uri)
							end
						end
					end
					table.sort(solutions)
					if #solutions > 0 then
						client:notify("solution/open", { solution = solutions[1] })
					elseif #projects > 0 then
						client:notify("project/open", { projects = projects })
					end
				end,
			})
			-- Executable dependencies come from programs.neovim.extraPackages.
			vim.lsp.enable({
				"lua_ls", "nil_ls", "ts_ls", "jsonls", "html", "cssls",
				"roslyn_ls", "rust_analyzer", "svelte", "tailwindcss",
			})
		end,
	},
}
