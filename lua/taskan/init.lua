local if_nil = vim.F.if_nil

local M = {}

M.task = require("taskan.task")
M.ui = require("taskan.ui")

function M.setup(config)
	-- config stuff
	if not config then
		config = {}
	end
	local default_config = {
		home = "list",
    format = "compact",
		theme = "catppuccin-latte",
		keys = {
			-- basics
			help = "?",
			quit = "q",
			-- views
			task_list = "l",
			project_list = "p",
			tag_list = "t",
			-- actions
			add_task = "a",
		},
	}
	vim.validate({ config = { config, "table" } })
	config.opts = vim.tbl_extend("keep", if_nil(config.opts, {}), default_config)

	-- START
	M.ui.start(config)
end

return M
