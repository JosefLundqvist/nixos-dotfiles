return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					path_display = { "smart" },
					-- theme = "dropdown",
				},
				pickers = {
					lsp_document_symbols = {
						theme = "dropdown",
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			require("telescope").load_extension("fzf")

			local builtin = require("telescope.builtin")
			local opts = {}
			vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
			vim.keymap.set("n", "<leader><leader>", builtin.find_files, opts)
			vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)
			vim.keymap.set("n", "<leader>fr", builtin.lsp_references, opts)
			vim.keymap.set("n", "<leader>fd", builtin.lsp_type_definitions, opts)
			vim.keymap.set("n", "<leader>fea", function()
				-- Show all diagnostics
				builtin.diagnostics()
			end)
			vim.keymap.set("n", "fm", builtin.lsp_document_symbols, opts)
			vim.keymap.set("n", "<leader>ft", function()
				builtin.lsp_dynamic_workspace_symbols({
					symbols = { "Class", "Struct", "Interface", "Enum" },
				})
			end, { desc = "Find types" })
		end,
	},
}
