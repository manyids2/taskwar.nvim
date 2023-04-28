-- bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Usability
	"folke/which-key.nvim",
	"nvim-treesitter/playground",
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- looks
	"godlygeek/tabular",
	"preservim/vim-markdown",
	{ "catppuccin/nvim", name = "catppuccin" },
})
