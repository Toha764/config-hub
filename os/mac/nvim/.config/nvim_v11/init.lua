--------------------------------------------------
-- Main Init File
-- Modularized NeoVim Configuration — nvim 0.11
--------------------------------------------------
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Transparent bg before any plugin loads
local function set_transparent()
	local groups = {
		"Normal",
		"NormalNC",
		"SignColumn",
		"EndOfBuffer",
		-- diagnostic signs (prevent red blocks in sign column)
		"DiagnosticSignError",
		"DiagnosticSignWarn",
		"DiagnosticSignInfo",
		"DiagnosticSignHint",
		-- git signs (prevent colored blocks in sign column)
		"GitSignsAdd",
		"GitSignsChange",
		"GitSignsDelete",
		"GitSignsTopdelete",
		"GitSignsChangedelete",
		"GitSignsUntracked",
	}
	for _, g in ipairs(groups) do
		vim.api.nvim_set_hl(0, g, { bg = "none" })
	end
end

set_transparent()

-- Re-apply after ColorScheme changes (e.g. switching themes at runtime)
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_transparent,
})

-- Core (order matters: keymaps sets leader, options sets editor, lazy loads plugins)
require("core.keymaps")
require("core.options")
require("core.lazy")

-- UI (loaded after plugins so highlights land on top)
require("ui.statusline")
require("ui.tabline").setup()
require("ui.terminal").setup()
