local M = {}

local ts_utils = require("nvim-treesitter.ts_utils")

function M.map(buf, mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, opts)
end

function M.is_in_list(node)
	if node:type() == "list" then
		return node
	else
		local parent = node:parent()

		-- if already root, return false
		if parent == nil then
			return false
		end

		-- while parent is list
		while parent ~= nil do
			if parent:type() == "list" then
				return parent
			else
				parent = parent:parent()
			end
		end
		return false
	end
end

-- keymaps
function M.set_keymaps(keys, state)
	local buf = state.buffer
	M.map(buf, "n", keys.help, ":echo 'help'<cr>", { desc = "Help" })
	M.map(buf, "n", keys.quit, "<cmd>qa<cr>", { desc = "Quit" })
	M.map(buf, "n", keys.task_list, ":echo 'task_list'<cr>", { desc = "List Tasks" })
	M.map(buf, "n", keys.project_list, ":echo 'project_list'<cr>", { desc = "List Projects" })
	M.map(buf, "n", keys.tag_list, ":echo 'tag_list'<cr>", { desc = "List Tags" })
	M.map(buf, "n", keys.add_task, ":echo 'add_task'<cr>", { desc = "Add Task" })
	M.map(buf, "n", "u", "", { desc = "Unbind undo for now" })
	M.map(buf, "n", "<c-r>", "", { desc = "Unbind undo for now" })

	-- enter
	M.map(buf, "n", "<cr>", "", {
		desc = "Expand",
		callback = function()
			local node = ts_utils.get_node_at_cursor()
			if node == nil then
				error("No Treesitter parser found.")
			end

			if (state.ttable.title == "list") or (state.ttable.title == "next") then
				-- get position of cursor
				local is_in_list = M.is_in_list(node)
				if is_in_list then
					local list = is_in_list
					print(list:type())
				else
					print("No parent list")
				end
			end
		end,
	})
end

return M
