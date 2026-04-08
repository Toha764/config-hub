-- ============================================================================
-- init.lua — loader only, all config lives in lua/config/
-- ============================================================================

require("config.theme")      -- colorscheme + transparency
require("config.options")    -- vim.opt settings
require("config.keymaps")    -- keybindings (sets mapleader first)
require("config.statusline") -- custom statusline
require("config.autocmds")   -- autocommands (returns augroup)
require("config.plugins")    -- vim.pack.add + packadd
-- plugin configs (order matters: treesitter before lsp)
require("config.treesitter")
require("config.nvimtree")
require("config.fzf")
require("config.mini")
require("config.gitsigns")
require("config.lsp")        -- LSP + blink.cmp + efm (needs augroup)
require("config.terminal")   -- floating terminal (needs augroup)
