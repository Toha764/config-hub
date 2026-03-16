local M = {}

function M.render()
	local s = ""
	local index = 0

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].buflisted then
			index = index + 1

			local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")

			if name == "" then
				name = "[No Name]"
			end

			if vim.bo[bufnr].modified then
				name = name .. " ●"
			end

			if bufnr == vim.api.nvim_get_current_buf() then
				s = s .. "%#TabLineSel#"
			else
				s = s .. "%#TabLine#"
			end

			s = s .. " " .. index .. ": " .. name .. " "
		end
	end

	return s
end

return M
