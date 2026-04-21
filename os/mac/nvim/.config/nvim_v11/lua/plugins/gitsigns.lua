--------------------------------------------------
-- Git Integration (Gitsigns)
--------------------------------------------------

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add          = { text = "\u{2590}" }, -- ▐
				change       = { text = "\u{2590}" },
				delete       = { text = "\u{2590}" },
				topdelete    = { text = "\u{25e6}" }, -- ◦
				changedelete = { text = "\u{25cf}" }, -- ●
				untracked    = { text = "\u{25cb}" }, -- ○
			},
			signcolumn          = true,
			current_line_blame  = false,
		})

		-- hunk navigation
		vim.keymap.set("n", "]h", function() require("gitsigns").next_hunk() end,                    { desc = "Next git hunk" })
		vim.keymap.set("n", "[h", function() require("gitsigns").prev_hunk() end,                    { desc = "Prev git hunk" })

		-- hunk operations
		vim.keymap.set("n", "<leader>hs", function() require("gitsigns").stage_hunk() end,           { desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>hr", function() require("gitsigns").reset_hunk() end,           { desc = "Reset hunk" })
		vim.keymap.set("n", "<leader>hp", function() require("gitsigns").preview_hunk() end,         { desc = "Preview hunk" })
		vim.keymap.set("n", "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })
		vim.keymap.set("n", "<leader>hB", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Toggle inline blame" })
		vim.keymap.set("n", "<leader>hd", function() require("gitsigns").diffthis() end,             { desc = "Diff this" })
		vim.keymap.set("n", "<leader>hD", function() require("gitsigns").diffthis("~") end,          { desc = "Diff this ~" })
		vim.keymap.set("n", "<leader>hu", function() require("gitsigns").undo_stage_hunk() end,      { desc = "Undo stage hunk" })
		vim.keymap.set("n", "<leader>hS", function() require("gitsigns").stage_buffer() end,         { desc = "Stage buffer" })
		vim.keymap.set("n", "<leader>hR", function() require("gitsigns").reset_buffer() end,         { desc = "Reset buffer" })

		-- visual mode hunk operations
		vim.keymap.set("v", "<leader>hs", function()
			require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage hunk (visual)" })
		vim.keymap.set("v", "<leader>hr", function()
			require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset hunk (visual)" })
	end,
}
