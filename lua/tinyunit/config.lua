local M = {}

-- Default font size constant
local DEFAULT_FONT_SIZE = 14

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
	font = {
		-- Base font size in pixels, always defaults to 16
		base_size = DEFAULT_FONT_SIZE,
		presets = {
			desktop = DEFAULT_FONT_SIZE, -- 16px
			mobile = DEFAULT_FONT_SIZE, -- 16px
			tablet = DEFAULT_FONT_SIZE, -- 16px
			large_display = DEFAULT_FONT_SIZE, -- 16px
		},
		-- Scale factors relative to 16px base
		scale_factors = {
			heading1 = 2.0, -- 32px
			heading2 = 1.5, -- 24px
			heading3 = 1.25, -- 20px
			small = 0.875, -- 14px
			caption = 0.75, -- 12px
		},
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
