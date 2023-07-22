local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wbutton = require("ui.widgets.button")

return function()
	local clock = wibox.widget({
		widget = wibox.widget.textclock,
		format = "%H:%M",
		align = "center",
		valign = "center",
		font = beautiful.font_name .. " Bold 14",
	})

	clock.markup = helpers.ui.colorize_text(clock.text, beautiful.white)
	clock:connect_signal("widget:redraw_needed", function()
		clock.markup = helpers.ui.colorize_text(clock.text, beautiful.white)
	end)
	helpers.ui.add_tooltip(clock, function()
		return os.date("%a - %B %d, %Y")
	end)

	local widget = wbutton.elevated.state({
		child = clock,
		normal_bg = beautiful.wibar_bg,
	})

	return widget
end
