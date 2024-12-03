local M = {}

function M.setup(opts)
	local config = require("tinyunit.config")
	config.setup(opts)

	local keymap_opts = { noremap = true, silent = true }

	vim.keymap.set("n", config.options.keymap.open, function()
		require("tinyunit.ui").open_converter()
	end, keymap_opts)

	vim.keymap.set("x", config.options.keymap.open, function()
		vim.cmd('noau normal! "vy"')
		local selected_text = vim.fn.getreg("v")
		vim.fn.setreg("v", {})

		if selected_text and selected_text ~= "" then
			require("tinyunit.ui").open_converter(selected_text:match("^%s*(.-)%s*$"))
		end
	end, keymap_opts)
end

return M
