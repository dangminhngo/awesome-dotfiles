local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local arcchart = { mt = {} }

function arcchart.state(args)
	args.min_value = args.min_value or 0
	args.max_value = args.min_value or 100
	args.value = args.value or 50
	args.thickness = args.thickness or dpi(4)
	args.start_angle = args.start_angle or math.pi + math.pi / 2
	args.bg = args.bg or beautiful.bg3
	args.colors = args.colors or { beautiful.fg }
	args.fg = args.fg or args.colors[1]
	args.width = args.width or dpi(24)
	args.height = args.height or dpi(24)
	args.text = args.text or ""
	args.font = args.font or beautiful.icon_font .. " Round"
	args.size = args.size or 10
	args.tooltip = args.tooltip or ""

	local widget = wibox.widget({
		{
			id = "arc",
			min_value = args.min_value,
			max_value = args.max_value,
			value = args.value,
			thickness = args.thickness,
			start_angle = args.start_angle,
			bg = args.bg,
			colors = args.colors,
			forced_width = args.width,
			forced_height = args.height,
			widget = wibox.container.arcchart,
		},
		{
			{
				markup = "<span foreground='" .. args.fg .. "'>" .. args.text .. "</span>",
				font = args.font .. " " .. args.size,
				widget = wibox.widget.textbox,
			},
			halign = "center",
			valign = "center",
			widget = wibox.container.place,
		},
		layout = wibox.layout.stack,
	})

	local tooltip = helpers.ui.add_tooltip(widget, args.tooltip)

	function widget:set_arc_value(...)
		widget:get_children_by_id("arc")[1]:set_value(...)
	end

	function widget:set_tooltip_text(...)
		tooltip:set_text(...)
	end

	function widget:set_tooltip_markup(...)
		tooltip:set_markup(...)
	end

	return widget
end

return setmetatable(arcchart, arcchart.mt)
