-- bootstrap lazy.nvim
require("configs.bootstrap")

-- sanity
require("configs.options")
require("configs.keymaps")

-- start taskwar
require("taskwar").setup({ opts = { theme = "catppuccin-latte" } })
