--------------------------------------------------
-- Editor Settings & Options
--------------------------------------------------

-- Behavior Settings
vim.opt.clipboard = "unnamedplus" -- Always use system clipboard
vim.opt.backspace = "indent,eol,start" -- Better backspace behavior
vim.opt.iskeyword:append("-") -- Treat dash as part of word
vim.opt.timeout = true
vim.opt.timeoutlen = 650
vim.opt.pumheight = 10 -- Popup menu height
vim.opt.pumblend = 10 -- Popup menu transparency
vim.opt.winblend = 0 -- Floating window transparency
vim.opt.synmaxcol = 300 -- Syntax highlighting limit
vim.opt.fillchars = { eob = " " } -- Hide ~ on empty lines

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- Visuals
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search settings
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search
vim.opt.hlsearch = false -- Don't highlight search results vim.opt.incsearch = true -- Show matches as you type

----------------------------------------------
--- Text Selection, Move, Copy, & Paste
----------------------------------------------

-- Delete without yanking (solves clipboard overwriting when text deleted)
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Move current line : All direction
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-----------------------------------------
--- Navigation
-----------------------------------------

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- ============================================================================
-- Tab, Buffer, and Split Window Settings
-- ============================================================================

-- Pookiefied Tab
vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.require('ui.tabline').render()"

-- Tab Open/Close as Buffer Logic
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>w", function()
	local current = vim.api.nvim_get_current_buf()
	local bufs = vim.tbl_filter(function(b)
		return vim.bo[b].buflisted
	end, vim.api.nvim_list_bufs())

	if #bufs <= 1 then
		vim.cmd("quit")
		return
	end

	-- Switch to adjacent buffer before closing
	for i, buf in ipairs(bufs) do
		if buf == current then
			local target = bufs[i + 1] or bufs[i - 1]
			vim.api.nvim_set_current_buf(target)
			break
		end
	end

	vim.api.nvim_buf_delete(current, { force = false })
end, { desc = "Close buffer" })

-- -- Buffer navigation
-- vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Split Window Creation and Resize
vim.keymap.set("n", "<leader>tv", "<cmd>vsplit<CR>", { silent = true })
vim.keymap.set("n", "<leader>th", "<cmd>split<CR>", { silent = true })
-- vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
-- vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
-- vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
-- vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Split window movement
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })

-- ============================================================================
-- File Backup and Swap
-- ============================================================================
local state = vim.fn.stdpath("state")

vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupdir = state .. "/backup//"
vim.opt.undofile = true -- persistent undo is essential
vim.opt.undodir = state .. "/undo//"
vim.opt.updatetime = 300 -- from first config, good for LSP responsiveness
vim.opt.autoread = true -- from first config, reload externally changed files

vim.fn.mkdir(state .. "/undo", "p")
vim.fn.mkdir(state .. "/backup", "p")

-- Autosave from second config
vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
	pattern = "*",
	command = "silent! wall",
})
-- ============================================================================
-- Quality of Life
-- ============================================================================

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank()
	end,
})
-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================

-- terminal
local terminal_state = {
	buf = nil,
	win = nil,
	is_open = false,
}
local function FloatingTerminal()
	-- Capture current file dir BEFORE any window switching
	local file_dir = vim.fn.expand("%:p:h")

	if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
		vim.api.nvim_win_close(terminal_state.win, false)
		terminal_state.is_open = false
		return
	end

	if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
		terminal_state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[terminal_state.buf].bufhidden = "hide"
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.wo[terminal_state.win].winblend = 0
	vim.wo[terminal_state.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
	vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

	local has_terminal = false
	local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
	for _, line in ipairs(lines) do
		if line ~= "" then
			has_terminal = true
			break
		end
	end

	if not has_terminal then
		-- Pass the directory here
		vim.fn.termopen(os.getenv("SHELL"), { cwd = file_dir })
	end

	terminal_state.is_open = true
	vim.cmd("startinsert")

	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = terminal_state.buf,
		callback = function()
			if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
				vim.api.nvim_win_close(terminal_state.win, false)
				terminal_state.is_open = false
			end
		end,
		once = true,
	})
end
-- Function to explicitly close the terminal
local function CloseFloatingTerminal()
	if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
		vim.api.nvim_win_close(terminal_state.win, false)
		terminal_state.is_open = false
	end
end

-- Key mappings

vim.keymap.set(
	"n",
	"<leader>tt",
	FloatingTerminal,
	{ noremap = true, silent = true, desc = "Toggle floating terminal" }
)
vim.keymap.set("t", "<Esc>", function()
	if terminal_state.is_open then
		vim.api.nvim_win_close(terminal_state.win, false)
		terminal_state.is_open = false
	end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })
