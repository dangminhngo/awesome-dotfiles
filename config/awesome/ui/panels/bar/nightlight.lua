local awful = require("awful")
local beautiful = require("beautiful")
local widgets = require("ui.widgets")
local helpers = require("helpers")

-- Nightlight Widget
return function()
	local nightlight = widgets.button.text.state({
		text_normal_bg = beautiful.black,
		normal_bg = beautiful.wibar_bg,
		font = beautiful.icon_font .. " Round ",
		size = 16,
		text = "",
	})

	local tooltip = helpers.ui.add_tooltip(nightlight, "Nightlight: Off")

	nightlight:connect_signal("button::release", function()
		awful.spawn.easy_async_with_shell([[~/.dotfiles/scripts/utils nightlight]], function(stdout)
			local state = helpers.misc.trim(stdout)
			if state == "on" then
				nightlight:set_text("")
				nightlight:set_color(beautiful.fg)
				tooltip:set_text("Nightlight: On")
			else
				nightlight:set_text("")
				nightlight:set_color(beautiful.black)
				tooltip:set_text("Nightlight: Off")
			end
		end)
	end)

	return nightlight
end
