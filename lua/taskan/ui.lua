local M = {}

local keymaps = require("taskan.keymaps")
local task = require("taskan.task")

-- shortcuts
local api = vim.api

function M.draw_frame(size, label)
	local loutput
	local output = {}

	-- dims
	local w = size[1]
	local h = size[2]

	-- top
	label = string.sub(label, 1, w - 2)
	loutput = "◜" .. label .. string.rep("⎺", w - 2 - string.len(label)) .. "◝"
	table.insert(output, loutput)
	-- sides
	for _ = 2, h - 2 do
		loutput = "⎸" .. string.rep(" ", w - 2) .. "⎹"
		table.insert(output, loutput)
	end
	-- bottom
	loutput = "◟" .. string.rep("⎽", w - 2) .. "◞"
	table.insert(output, loutput)
	return output
end

function M.render(showing, buffer)
	api.nvim_buf_set_lines(buffer, -1, -1, false, { "# " .. showing, "" })

	-- tasks
	local ttable = task.get_ttable("!task " .. showing)
	local lines = task.format_ttable(ttable)
	api.nvim_buf_set_lines(buffer, -1, -1, false, lines)

	api.nvim_buf_set_lines(buffer, -1, -1, false, { "" })
	api.nvim_buf_set_mark(buffer, "m", 2, 1, {})
end

function M.start(config)
	-- theme
	vim.cmd("colorscheme " .. config.opts.theme)

	-- buffer
	local buffer = api.nvim_create_buf(false, true)
	api.nvim_buf_set_option(buffer, "filetype", "markdown")

	-- render content
	M.render("list", buffer)
	M.render("projects", buffer)
	M.render("tags", buffer)

	-- ui
	local window = api.nvim_get_current_win()
	api.nvim_win_set_buf(window, buffer)

	-- keymaps
	keymaps.set_keymaps(config.opts.keys, buffer)

	-- state
	local state = {
		line = 0,
		buffer = buffer,
		window = window,
		win_width = 0,
		open = true,
	}
	return state
end

return M
