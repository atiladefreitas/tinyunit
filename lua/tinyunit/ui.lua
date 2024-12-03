local api = vim.api
local config = require("tinyunit.config")
local state = require("tinyunit.state")

local M = {}
local input_win_id = nil
local input_buf_id = nil
local results_win_id = nil
local results_buf_id = nil
local original_selection = {
	start_pos = nil,
	end_pos = nil,
	text = nil,
}

local function center_of_screen()
	local ui = vim.api.nvim_list_uis()[1]
	return math.floor(ui.width / 2), math.floor(ui.height / 2)
end

local function create_windows()
	local opts = config.options.window
	local width = opts.width
	local height = opts.height
	local center_x, center_y = center_of_screen()

	input_buf_id = api.nvim_create_buf(false, true)
	local input_win_opts = {
		relative = "editor",
		width = width,
		height = 1,
		row = center_y - 6,
		col = center_x - math.floor(width / 2),
		style = "minimal",
		border = "rounded",
		title = opts.input_title,
		title_pos = "center",
	}
	input_win_id = api.nvim_open_win(input_buf_id, true, input_win_opts)

	results_buf_id = api.nvim_create_buf(false, true)
	local results_win_opts = {
		relative = "editor",
		width = width,
		height = height,
		row = center_y - 4,
		col = center_x - math.floor(width / 2),
		style = "minimal",
		border = "rounded",
		title = " Unit Converter ",
		title_pos = "center",
		footer = " <Enter> to paste ",
		footer_pos = "center",
	}
	results_win_id = api.nvim_open_win(results_buf_id, false, results_win_opts)

	for _, buf_id in ipairs({ input_buf_id, results_buf_id }) do
		api.nvim_buf_set_option(buf_id, "modifiable", true)
		api.nvim_buf_set_option(buf_id, "buftype", "nofile")
		api.nvim_buf_set_option(buf_id, "bufhidden", "wipe")
	end

	local input_keymap_opts = { noremap = true, silent = true, buffer = input_buf_id }
	vim.keymap.set("i", config.options.keymap.convert, function()
		local value = api.nvim_get_current_line()
		vim.cmd("stopinsert")
		api.nvim_win_close(input_win_id, true)
		api.nvim_set_current_win(results_win_id)
		M.convert_value(value)
	end, input_keymap_opts)

	vim.keymap.set("i", config.options.keymap.escape, function()
		M.close_windows()
	end, input_keymap_opts)

	local results_keymap_opts = { noremap = true, silent = true, buffer = results_buf_id }
	vim.keymap.set("n", config.options.keymap.convert, function()
		M.select_and_replace()
	end, results_keymap_opts)

	vim.keymap.set("n", config.options.keymap.close, function()
		M.close_windows()
	end, results_keymap_opts)

	vim.keymap.set("n", config.options.keymap.escape, function()
		M.close_windows()
	end, results_keymap_opts)

	vim.cmd("startinsert")
end

function M.close_windows()
	if input_win_id and api.nvim_win_is_valid(input_win_id) then
		api.nvim_win_close(input_win_id, true)
	end
	if results_win_id and api.nvim_win_is_valid(results_win_id) then
		api.nvim_win_close(results_win_id, true)
	end
end

function M.convert_value(input)
	local value, unit = state.parse_value(input)
	if value and unit then
		local conversions = state.convert_value(value, unit)
		api.nvim_buf_set_lines(results_buf_id, 0, -1, false, conversions)
	end
end

function M.select_and_replace()
	local cursor = vim.api.nvim_win_get_cursor(results_win_id)
	local selected_value = vim.api.nvim_buf_get_lines(results_buf_id, cursor[1] - 1, cursor[1], false)[1]

	if selected_value then
		-- Copy to clipboard
		vim.fn.setreg("+", selected_value)
		vim.fn.setreg('"', selected_value)

		local target_win = nil
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			if buf ~= input_buf_id and buf ~= results_buf_id then
				target_win = win
				break
			end
		end

		if target_win then
			vim.api.nvim_set_current_win(target_win)
			-- Execute normal mode paste command
			vim.cmd('normal! viw"_dP')
		end

		M.close_windows()
	end
end

function M.open_converter(initial_value)
	if input_win_id and api.nvim_win_is_valid(input_win_id) then
		M.close_windows()
	end

	if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
		vim.cmd('noau normal! "vy"')
		local selected_text = vim.fn.getreg("v")
		vim.fn.setreg("v", {})

		if selected_text and selected_text ~= "" then
			original_selection.start_pos = vim.fn.getpos("'<")
			original_selection.end_pos = vim.fn.getpos("'>")
			original_selection.text = selected_text:match("^%s*(.-)%s*$")
			initial_value = original_selection.text
		end
	else
		original_selection.start_pos = nil
		original_selection.end_pos = nil
		original_selection.text = nil
	end

	create_windows()

	if initial_value then
		api.nvim_buf_set_lines(input_buf_id, 0, -1, false, { initial_value })
		M.convert_value(initial_value)
	end
end

return M
