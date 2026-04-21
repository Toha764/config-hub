--------------------------------------------------
-- Treesitter Configuration
--------------------------------------------------
return {
	"nvim-treesitter/nvim-treesitter",
	event = "BufReadPost",
	build = ":TSUpdate",
	config = function()
		local status, configs = pcall(require, "nvim-treesitter.configs")
		if not status then
			return
		end

		configs.setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"python",
				"javascript",
				"typescript",
				"go",
				"rust",
				"html",
				"css",
				"json",
				"bash",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
		})
	end,
}
