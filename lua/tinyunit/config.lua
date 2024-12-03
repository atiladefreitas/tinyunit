local M = {}

-- Default font size constant
local DEFAULT_FONT_SIZE = 16

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
	-- Simplified font configuration
	font = {
		base_size = DEFAULT_FONT_SIZE, -- Base font size in pixels, always defaults to 16
	},
}

M.options = {
	base_font_size = DEFAULT_FONT_SIZE,
}

function M.setup(opts)
	-- Deep merge of defaults and user options
	M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})

	-- Ensure base font size is set and valid
	if not M.options.font or not M.options.font.base_size or M.options.font.base_size <= 0 then
		vim.notify("Invalid font size configuration. Using default: 16px", vim.log.levels.WARN)
		M.options.font = M.options.font or {}
		M.options.font.base_size = DEFAULT_FONT_SIZE
	end

	-- Always update base_font_size from font.base_size
	M.options.base_font_size = M.options.font.base_size
end

return M
