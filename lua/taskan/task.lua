local M = {}

M.cols_line = 4
M.dashes_line = 5
M.summary_col = { list = 5, projects = 1, tags = 1 }

function M.extend_table(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
end

function M.get_cmd_lines(cmd)
	local output = vim.api.nvim_exec(cmd, true)
	return vim.split(output, "\n", { plain = true })
end

function M.get_col_lengths(lines)
	local slengths = vim.split(lines[M.dashes_line], " ", {})
	local lengths = {}
	local current = 0
	for k, v in pairs(slengths) do
		--- 1.ID .4.Age Project      Tags  Description    Urg
		current = current + 1
		local new = current + string.len(v)
		lengths[k] = { current, new }
		current = new
	end
	return lengths
end

function M.get_cells(line, lengths)
	local cells = {}
	for k, v in pairs(lengths) do
		cells[k] = vim.trim(string.sub(line, v[1], v[2]))
	end
	return cells
end

function M.get_ttable(showing)
	-- Get lengths and columns
	local lines = M.get_cmd_lines("!task " .. showing)
	local lengths = M.get_col_lengths(lines)
	local columns = M.get_cells(lines[M.cols_line], lengths)

	-- Filter only relevant lines
	local capture = true
	local count = 1
	local filtered = {}
	for k, v in pairs(lines) do
		if k > M.dashes_line then
			if capture and (string.len(vim.trim(v)) == 0) then
				capture = false
			end
			if capture then
				filtered[count] = v
				count = count + 1
			end
		end
	end

	-- Convert to cells
	local cells = {}
	for k, line in pairs(filtered) do
		cells[k] = M.get_cells(line, lengths)
	end

	-- Return table
	local ttable = { title = showing, lengths = lengths, columns = columns, cells = cells }
	return ttable
end

function M.cap_output(loutput, k, n_cols, separator)
	if not separator then
		separator = " | "
	end
	if k ~= n_cols then
		loutput = loutput .. separator
	else
		loutput = loutput .. separator
	end
	return loutput
end

function M.format_cells(cells, lengths, n_cols)
	local loutput = "| "
	for k, column in pairs(cells) do
		local length = lengths[k][2] - lengths[k][1]
		local padding = length - string.len(column) + 1
		loutput = loutput .. string.format("%s", column) .. string.rep(" ", padding)
		loutput = M.cap_output(loutput, k, n_cols)
	end
	return loutput
end

function M.format_separator(columns, lengths, n_cols)
	local loutput = "| "
	for k, column in pairs(columns) do
		local length = lengths[k][2] - lengths[k][1]
		local padding = length - string.len(column)
		loutput = loutput .. string.rep("-", string.len(column) + 1) .. string.rep(" ", padding)
		loutput = M.cap_output(loutput, k, n_cols)
	end
	return loutput
end

function M.get_as_list(cells, columns)
	local loutput
	local output = { "" }
	for k, cell in pairs(cells) do
		loutput = "  - " .. columns[k] .. " : " .. cell
		table.insert(output, loutput)
	end
	table.insert(output, "")
	return output
end

function M.format_ttable(ttable, format)
	local loutput
	local output = { "# " .. ttable.title, "" }

	-- rows
	if format == "sections" then
		for _, cells in pairs(ttable.cells) do
			M.extend_table(output, { "## " .. cells[1] })
			loutput = M.get_as_list(cells, ttable.columns)
			M.extend_table(output, loutput)
		end
	else
		for _, cells in pairs(ttable.cells) do
			if string.len(cells[1]) > 0 then
				loutput = "- [ ] "
			else
				loutput = "      "
			end
			loutput = loutput .. cells[M.summary_col[ttable.title]]
			table.insert(output, loutput)
		end
	end
	return output
end

return M
