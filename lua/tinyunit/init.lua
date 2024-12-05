local M = {}

local function setup_commands()
	vim.api.nvim_create_user_command("TinyUnitParent", function(opts)
		local size = tonumber(opts.args)
		if require("tinyunit.config").set_parent_font_size(size) then
			vim.notify(string.format("Parent font size set to %dpx", size), vim.log.levels.INFO)
		end
	end, {
		nargs = 1,
		desc = "Set parent font size for em calculations",
	})
end

function M.setup(opts)
	local config = require("tinyunit.config")
	config.setup(opts)

	local keymap_opts = {
		noremap = true,
		silent = true,
		desc = "Open TinyUnit converter",
	}

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

	setup_commands()
end

return M
