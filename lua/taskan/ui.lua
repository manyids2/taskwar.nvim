local M = {}

M.state = {
	line = 0,
	buffer = nil,
	window = nil,
	win_width = 0,
	open = true,
	ttable = nil,
	dirty = true,
}

local keymaps = require("taskan.keymaps")
local task = require("taskan.task")

-- shortcuts
local api = vim.api

function M.render()
	local buffer = M.state.buffer
	local ttable = M.state.ttable

	if not buffer then
		return
	end

	if M.state.dirty then
		-- table
		local lines = task.format_ttable(ttable)
		api.nvim_buf_set_lines(buffer, -1, -1, false, lines)
	end
end

function M.start(config)
	-- theme
	vim.cmd("colorscheme " .. config.opts.theme)

	-- create lists buffer
	local buffer = api.nvim_create_buf(false, true)
	api.nvim_buf_set_option(buffer, "filetype", "markdown")

	-- focus
	local window = api.nvim_get_current_win()
	api.nvim_win_set_buf(window, buffer)

	-- data
	local ttable = task.get_ttable(config.opts.home)

	-- state
	M.state.buffer = buffer
	M.state.window = window
	M.state.ttable = ttable

	-- keymaps
	keymaps.set_keymaps(config.opts.keys, M.state)

	-- render content
	M.render()
end

return M
