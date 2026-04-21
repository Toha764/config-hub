require("config.theme") -- colorscheme + transparency
require("config.options") -- vim.opt settings
require("config.keymaps") -- keybindings
-- require("config.statusline") -- custom statusline
require("config.plugins") -- vim.pack.add + packadd

require("config.lualine")
require("config.autocmds") -- autocommands
require("config.alpha")
require("config.leet")
require("config.colorizer")

-- treesitter must come before lsp
require("config.treesitter")

require("config.yazi")
require("config.fzf")
require("config.gitsigns")
require("config.lsp") -- LSP + blink.cmp + efm
require("config.terminal") -- floating terminal
require("config.mini")
require("config.markdown")
require("config.smear-cursor") -- smear cursor effect