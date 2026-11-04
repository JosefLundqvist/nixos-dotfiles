return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		-- use a release tag to download pre-built binaries
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = { preset = "default" },
			completion = {
				menu = { border = "single" },
				documentation = { auto_show = true, window = { border = "single" } },
			},

			signature = {
				enabled = true,
			},

			cmdline = {
				completion = {
					menu = {
						auto_show = true,
					},
				},
			},

			appearance = {
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				--default = { "lsp", "path", "buffer" },
			},
			fuzzy = {
				implementation = vim.env.NVIM_NIX_MANAGED == "1" and "lua" or "prefer_rust_with_warning",
			},
		},
		opts_extend = { "sources.default" },
	},
}
