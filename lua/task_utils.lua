local api = vim.api

local function isempty(s)
	return s == nil or s == ""
end

local function get_projects()
	local projects = {}
	local lines = vim.split(vim.api.nvim_exec("!task projects", true), "\n", { plain = true })
	for _, x in pairs(lines) do
		x = vim.trim(x)
		if not isempty(x) then
			if string.sub(x, 1, 1) == ":" then
			elseif string.sub(x, 1, 7) == "Project" then
			elseif string.sub(x, 1, 7) == "-------" then
			elseif x:match("^%-?%d+") then
				break
			else
				local name = vim.split(x, " ")[1]
				table.insert(projects, name)
			end
		end
	end
	return projects
end

local function get_tags()
	local tags = {}
	local lines = vim.split(vim.api.nvim_exec("!task tags", true), "\n", { plain = true })
	for _, x in pairs(lines) do
		x = vim.trim(x)
		if not isempty(x) then
			if string.sub(x, 1, 1) == ":" then
			elseif string.sub(x, 1, 3) == "Tag" then
			elseif string.sub(x, 1, 3) == "---" then
			elseif x:match("^%-?%d+") then
				break
			elseif x:match("^\\(%-?%d+") then
			else
				local name = vim.split(x, " ")[1]
				table.insert(tags, name)
			end
		end
	end
	return tags
end

local function open_window(items)
	local buf = api.nvim_create_buf(false, true) -- create new emtpy buffer
	api.nvim_buf_set_option(buf, "bufhidden", "wipe")

	-- set output
	vim.api.nvim_buf_set_lines(buf, -1, -1, true, items)
  api.nvim_buf_set_option(buf, "modifiable", false)

	-- get dimensions
	local width = api.nvim_get_option("columns")
	local height = api.nvim_get_option("lines")

	-- calculate our floating window size
	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)

	-- and its starting position
	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)

	-- set some options
	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
	}

	-- and finally create it with buffer attached
	local win = api.nvim_open_win(buf, true, opts)

	return { win, buf }
end

local projects = get_projects()
local tags = get_tags()

local ret = open_window(projects)
local win = ret[0]
local buf = ret[1]
