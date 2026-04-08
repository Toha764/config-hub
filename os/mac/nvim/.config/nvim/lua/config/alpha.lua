local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  [[                                ]],
  [[                                ]],
  [[          ⠀⠀⠀⠀⠀⠀⢀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀     ]],
  [[          ⠀⠀⠀⠀⠀⢀⣾⣿⡇⠀⠀⠀⠀⠀⢀⣼⡇     ]],
  [[          ⠀⠀⠀⠀⠀⣸⣿⣿⡇⠀⠀⠀⠀⣴⣿⣿⠃     ]],
  [[          ⠀⠀⠀⠀⢠⣿⣿⣿⣇⠀⠀⢀⣾⣿⣿⣿⠀     ]],
  [[          ⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⡟⠀     ]],
  [[          ⠀⠀⢰⡿⠉⠀⡜⣿⣿⣿⡿⠿⢿⣿⣿⠃⠀     ]],
  [[          ⠒⠒⠸⣿⣄⡘⣃⣿⣿⡟⢰⠃⠀⢹⣿⡇⠀     ]],
  [[          ⠚⠉⠀⠈⠻⣿⣿⣿⣿⣿⣮⣤⣤⣿⡟⠁⠀     ]],
  [[          ⠀⠀⠀⠀⠀⠀⠈⠙⠛⠛⠛⠛⠛⠁⠀⠒⠤     ]],
  [[         ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠀⠀      ]],
  [[                                ]],
  [[                                ]],
}

dashboard.section.buttons.val = {
  dashboard.button("e", "  New file", ":ene <CR>"),
  dashboard.button("f", "  Find file", ":lua require('fzf-lua').files()<CR>"),
  dashboard.button("l", "< >Leet code", ":Leet<CR>"),
  dashboard.button("q", "⏻   Quit", ":qa<CR>"),
}

alpha.setup(dashboard.opts)
