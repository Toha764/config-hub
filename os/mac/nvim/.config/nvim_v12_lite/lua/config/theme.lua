vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")

local function set_transparent() -- set UI component to transparent
	local groups = {
		"Normal",
		"NormalNC",
		"EndOfBuffer",
		"NormalFloat",
		"FloatBorder",
		"SignColumn",
		"StatusLine",
		"StatusLineNC",
		"TabLine",
		"TabLineFill",
		"TabLineSel",
		"ColorColumn",
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
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
end

set_transparent()

-- Re-apply after ColorScheme changes (e.g. switching themes at runtime)
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_transparent,
})
