local M = {}

function M.map(buf, mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, opts)
end

-- keymaps
function M.set_keymaps(keys, buf)
	M.map(buf, "n", keys.help, ":echo 'help'<cr>", { desc = "Help" })
	M.map(buf, "n", keys.quit, "<cmd>qa<cr>", { desc = "Quit" })
	M.map(buf, "n", keys.task_list, ":echo 'task_list'<cr>", { desc = "List Tasks" })
	M.map(buf, "n", keys.project_list, ":echo 'project_list'<cr>", { desc = "List Projects" })
	M.map(buf, "n", keys.tag_list, ":echo 'tag_list'<cr>", { desc = "List Tags" })
	M.map(buf, "n", keys.add_task, ":echo 'add_task'<cr>", { desc = "Add Task" })
	M.map(buf, "n", "u", "", { desc = "Unbind undo for now" })
	M.map(buf, "n", "<c-r>", "", { desc = "Unbind undo for now" })
end

return M
