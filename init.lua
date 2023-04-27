-- bootstrap lazy.nvim
require("configs.bootstrap")

-- sanity
require("configs.options")
require("configs.keymaps")

-- start taskan
require("taskan").setup({ opts = { theme = "catppuccin-latte" } })
