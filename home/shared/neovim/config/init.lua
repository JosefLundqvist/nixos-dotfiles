require("jwl.lazy")

-- Keymaps

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("i", "<C-c>", "<Esc>", opts)
map("n", "Q", "<nop>", opts)

map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

map("n", "<leader>y", '"+y', opts)
map("v", "<leader>y", '"+y', opts)
map("n", "<leader>Y", '"+Y', opts)
map("n", "<leader>p", '"+p', opts)
map("v", "<leader>p", '"+p', opts)
map("n", "<leader>P", '"+P', opts)

map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })
map("n", "*", "*zz", { silent = true })
map("n", "#", "#zz", { silent = true })

map("n", "qj", ":cnext<cr>", opts)
map("n", "qk", ":cprev<cr>", opts)

map("n", "<leader>fe", vim.diagnostic.open_float)

map("n", "<leader>e", require("oil").toggle_float)

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("jwl", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.diagnostic.config({
	virtual_text = { current_line = true },
	virtual_lines = false,
	float = { border = "rounded" },
})

vim.o.winborder = "rounded"

-- Enable highlighting
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf = args.buf

		if vim.bo[buf].buftype ~= "" then
			return
		end

		pcall(vim.treesitter.start, buf)
	end,
})

-- Optional: enable additional modules
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
