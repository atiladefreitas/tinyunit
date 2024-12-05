local M = {}
local config = require("tinyunit.config")

-- get base font size
local function get_base_font_size()
	return config.options.base_font_size or 16
end

local function get_parent_font_size()
	return config.options.parent_font_size or get_base_font_size()
end

M.base_units = {
	"px",
	"rem",
	"em",
	"mm",
	"cm",
	"in",
	"pt",
	"vh",
	"vw",
}

local CONSTANTS = {
	PX_PER_INCH = 96,
	PT_PER_INCH = 72,
	MM_PER_INCH = 25.4,
	CM_PER_INCH = 2.54,
}

M.conversions = {
	px = {
		to_rem = function(value)
			return value / get_base_font_size()
		end,
		to_em = function(value)
			return value / get_parent_font_size()
		end,
		to_mm = function(value)
			return (value / CONSTANTS.PX_PER_INCH) * CONSTANTS.MM_PER_INCH
		end,
		to_cm = function(value)
			return (value / CONSTANTS.PX_PER_INCH) * CONSTANTS.CM_PER_INCH
		end,
		to_in = function(value)
			return value / CONSTANTS.PX_PER_INCH
		end,
		to_pt = function(value)
			return (value / CONSTANTS.PX_PER_INCH) * CONSTANTS.PT_PER_INCH
		end,
	},
	rem = {
		to_px = function(value)
			return value * get_base_font_size()
		end,
		to_em = function(value)
			return (value * get_base_font_size()) / get_parent_font_size()
		end,
		to_mm = function(value)
			return (value * get_base_font_size() / CONSTANTS.PX_PER_INCH) * CONSTANTS.MM_PER_INCH
		end,
		to_cm = function(value)
			return (value * get_base_font_size() / CONSTANTS.PX_PER_INCH) * CONSTANTS.CM_PER_INCH
		end,
		to_in = function(value)
			return (value * get_base_font_size()) / CONSTANTS.PX_PER_INCH
		end,
		to_pt = function(value)
			return (value * get_base_font_size() / CONSTANTS.PX_PER_INCH) * CONSTANTS.PT_PER_INCH
		end,
	},
	em = {
		to_px = function(value)
			return value * get_base_font_size()
		end,
		to_rem = function(value)
			return (value * get_parent_font_size()) / get_base_font_size()
		end,
		to_mm = function(value)
			return (value * get_base_font_size() / CONSTANTS.PX_PER_INCH) * CONSTANTS.MM_PER_INCH
		end,
		to_cm = function(value)
			return (value * get_base_font_size() / CONSTANTS.PX_PER_INCH) * CONSTANTS.CM_PER_INCH
		end,
		to_in = function(value)
			return (value * get_base_font_size()) / CONSTANTS.PX_PER_INCH
		end,
		to_pt = function(value)
			return (value * get_base_font_size() / CONSTANTS.PX_PER_INCH) * CONSTANTS.PT_PER_INCH
		end,
	},
	mm = {
		to_px = function(value)
			return (value / CONSTANTS.MM_PER_INCH) * CONSTANTS.PX_PER_INCH
		end,
		to_rem = function(value)
			return ((value / CONSTANTS.MM_PER_INCH) * CONSTANTS.PX_PER_INCH) / get_base_font_size()
		end,
		to_em = function(value)
			return ((value / CONSTANTS.MM_PER_INCH) * CONSTANTS.PX_PER_INCH) / get_base_font_size()
		end,
		to_cm = function(value)
			return value / 10
		end,
		to_in = function(value)
			return value / CONSTANTS.MM_PER_INCH
		end,
		to_pt = function(value)
			return (value / CONSTANTS.MM_PER_INCH) * CONSTANTS.PT_PER_INCH
		end,
	},
	cm = {
		to_px = function(value)
			return (value / CONSTANTS.CM_PER_INCH) * CONSTANTS.PX_PER_INCH
		end,
		to_rem = function(value)
			return ((value / CONSTANTS.CM_PER_INCH) * CONSTANTS.PX_PER_INCH) / get_base_font_size()
		end,
		to_em = function(value)
			return ((value / CONSTANTS.CM_PER_INCH) * CONSTANTS.PX_PER_INCH) / get_base_font_size()
		end,
		to_mm = function(value)
			return value * 10
		end,
		to_in = function(value)
			return value / CONSTANTS.CM_PER_INCH
		end,
		to_pt = function(value)
			return (value / CONSTANTS.CM_PER_INCH) * CONSTANTS.PT_PER_INCH
		end,
	},
	["in"] = {
		to_px = function(value)
			return value * CONSTANTS.PX_PER_INCH
		end,
		to_rem = function(value)
			return (value * CONSTANTS.PX_PER_INCH) / get_base_font_size()
		end,
		to_em = function(value)
			return (value * CONSTANTS.PX_PER_INCH) / get_base_font_size()
		end,
		to_mm = function(value)
			return value * CONSTANTS.MM_PER_INCH
		end,
		to_cm = function(value)
			return value * CONSTANTS.CM_PER_INCH
		end,
		to_pt = function(value)
			return value * CONSTANTS.PT_PER_INCH
		end,
	},
	pt = {
		to_px = function(value)
			return (value / CONSTANTS.PT_PER_INCH) * CONSTANTS.PX_PER_INCH
		end,
		to_rem = function(value)
			return ((value / CONSTANTS.PT_PER_INCH) * CONSTANTS.PX_PER_INCH) / get_base_font_size()
		end,
		to_em = function(value)
			return ((value / CONSTANTS.PT_PER_INCH) * CONSTANTS.PX_PER_INCH) / get_base_font_size()
		end,
		to_mm = function(value)
			return (value / CONSTANTS.PT_PER_INCH) * CONSTANTS.MM_PER_INCH
		end,
		to_cm = function(value)
			return (value / CONSTANTS.PT_PER_INCH) * CONSTANTS.CM_PER_INCH
		end,
		to_in = function(value)
			return value / CONSTANTS.PT_PER_INCH
		end,
	},
}

function M.parse_value(input)
	if not input or input == "" then
		return nil, nil
	end
	local value, unit = string.match(input, "([%d%.]+)(%a+)")
	return tonumber(value), unit
end

local function format_number(num)
	if math.floor(num) == num then
		return string.format("%d", num)
	else
		return string.format("%.4f", num):gsub("%.?0+$", "")
	end
end

function M.convert_value(value, from_unit)
	local results = {}
	if not value or not from_unit then
		return results
	end

	local conversions = M.conversions[from_unit]
	if not conversions then
		return results
	end

	for conv_name, converter in pairs(conversions) do
		local to_unit = conv_name:match("to_(.+)")
		if to_unit then
			local converted = converter(value)
			table.insert(results, format_number(converted) .. to_unit)
		end
	end

	table.sort(results)
	return results
end

return M
