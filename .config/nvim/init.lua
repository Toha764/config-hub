--------------------------------------------------
-- Main Init File
-- Modularized NeoVim Configuration
--------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- Load core settings (includes leader key setup)
require("core.keymaps")

-- Bootstrap lazy.nvim
require("core.lazy")

-- Load editor options
require("core.options")

-- Tab Switching Logic
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function()
		local count = 0

		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buflisted then
				count = count + 1
				if count == i then
					vim.api.nvim_set_current_buf(buf)
					return
				end
			end
		end
	end, { desc = "Go to Buffer " .. i })
end
