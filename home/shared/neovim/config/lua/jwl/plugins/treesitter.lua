return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		-- config = function()
		-- 	require("nvim-treesitter.configs").setup({
		-- 		auto_install = false,
		-- 		sync_install = false,
		-- 		ensure_installed = { 'rust', 'svelte', 'html', 'csharp' },
		-- 		ignore_install = {},
		-- 		highlight = {
		-- 			enable = true,
		-- 		},
		-- 		additional_vim_regex_highlighting = false,
		-- 		indent = { enable = true },
		-- 	})
		-- end,
	},
}
