local M = {}

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

return M
