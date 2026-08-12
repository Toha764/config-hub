-- nvim_v12_lite — minimal server-friendly config
-- Based on nvim_v12, stripped of LSP, treesitter, fzf, nvim-tree

require("config.theme")      -- colorscheme + transparency
require("config.options")    -- vim.opt settings
require("config.keymaps")    -- keybindings
require("config.statusline") -- custom statusline
require("config.autocmds")   -- autocommands
require("config.plugins")    -- vim.pack.add (minimal set)
require("config.mini")       -- mini.nvim modules
require("config.gitsigns")   -- git signs
require("config.terminal")   -- floating terminal
