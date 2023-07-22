local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local statarc = { mt = {} }

local function new(args)
	args = args or {}
	args.text = args.text or ""
	args.font = args.font or beautiful.icon_font .. " Round 10"
	args.min_value = args.min_value or 0
	args.max_value = args.max_value or 100
	args.value = args.value or 100
	args.thickness = args.thickness or dpi(4)
	args.start_angle = args.start_angle or math.pi + math.pi / 2
	args.bg = args.bg or beautiful.black
	args.fg = args.fg or beautiful.accent
	args.width = args.width or dpi(24)
	args.height = args.height or dpi(24)

	local text = wibox.widget({
		{
			markup = "<span foreground='" .. args.fg .. "'>" .. args.text .. "</span>",
			font = args.font,
			widget = wibox.widget.textbox,
		},
		halign = "center",
		valign = "center",
		widget = wibox.container.place,
	})

	local widget = wibox.widget({
		text,
		min_value = args.min_value,
		max_value = args.max_value,
		value = args.value,
		thickness = args.thickness,
		start_angle = args.start_angle,
		bg = args.bg,
		colors = { args.fg },
		rounded_edge = true,
		forced_width = args.width,
		forced_height = args.height,
		widget = wibox.container.arcchart,
	})
	local tooltip = helpers.ui.add_tooltip(widget, "CPU Usage")

	function widget:set_tooltip_text(...)
		tooltip:set_text(...)
	end

	function widget:set_tooltip_markup(...)
		tooltip:set_markup(...)
	end

	return widget
end

function statarc.mt:__call(...)
	return new(...)
end

return setmetatable(statarc, statarc.mt)
