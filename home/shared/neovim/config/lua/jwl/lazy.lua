local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
if vim.env.NVIM_NIX_MANAGED == "1" then
	lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json"
	local uv = vim.uv or vim.loop
	if not uv.fs_stat(lockfile) then
		local lockfile_dir = vim.fs.dirname(lockfile)
		vim.fn.mkdir(lockfile_dir, "p")
		local ok, err = uv.fs_copyfile(vim.fn.stdpath("config") .. "/lazy-lock.json", lockfile)
		if not ok then
			error("Failed to seed lazy.nvim lockfile: " .. tostring(err))
		end
	end
	-- fs_copyfile preserves the Nix store source's read-only mode.
	local ok, err = uv.fs_chmod(lockfile, 384) -- 0600
	if not ok then
		error("Failed to make lazy.nvim lockfile writable: " .. tostring(err))
	end
end

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.o.showmode = false

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.guicursor = ""
vim.opt.cursorline = true
vim.opt.termguicolors = true

vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 10

vim.opt.vb = true
vim.opt.updatetime = 50

require("lazy").setup({
	lockfile = lockfile,
	spec = {
		{ import = "jwl.plugins" },
	},
})
