return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
			delete_to_trash = true,
			float = {
				padding = 2,
				max_width = 0.8,
				max_height = 0.8,
				border = "rounded",
			},
		})
	end,
	dependencies = {
		"echasnovski/mini.nvim",
	},
}
