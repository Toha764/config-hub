-- ============================================================================
-- PLUGINS (vim.pack) — lite: no LSP, treesitter, fzf, or nvim-tree
-- ============================================================================
vim.pack.add({
	"https://www.github.com/lewis6991/gitsigns.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/folke/which-key.nvim",
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end
packadd("gitsigns.nvim")
packadd("mini.nvim")
packadd("which-key.nvim")
