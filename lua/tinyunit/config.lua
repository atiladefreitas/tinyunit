local M = {}

M.defaults = {
	window = {
		width = 30,
		height = 15,
		border = "rounded",
		input_title = "Enter Value",
	},
	keymap = {
		open = "<leader>tc",
		close = "q",
		convert = "<CR>",
		escape = "<Esc>",
	},
	units = {
		"px",
		"rem",
		"em",
		"vh",
		"vw",
		"mm",
		"cm",
		"in",
		"pt",
	},
}

M.options = {
	base_font_size = 16,
}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
