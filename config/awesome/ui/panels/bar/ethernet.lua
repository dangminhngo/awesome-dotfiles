local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local apps = require("configs.apps")
local widgets = require("ui.widgets")
local helpers = require("helpers")

-- Ethernet Widget

return function()
	local ethernet = widgets.button.text.state({
		text_normal_bg = beautiful.fg,
		normal_bg = beautiful.wibar_bg,
		font = beautiful.icon_font .. " Round ",
		size = 18,
		text = "",
		on_release = function()
			awful.spawn(apps.default.network_manager, false)
		end,
	})

	awful.widget.watch([[sh -c "nmcli g | tail -n 1 | awk '{print $1}'"]], 15, function(_, stdout)
		local net_ssid = helpers.misc.trim(stdout)
		if net_ssid:match("connected") then
			ethernet:set_text("")
			ethernet:set_color(beautiful.fg)
		else
			ethernet:set_text("")
			ethernet:set_color(beautiful.black)
		end
	end)

	return ethernet
end
