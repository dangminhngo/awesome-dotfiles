local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local widgets = require("ui.widgets")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

return function()
	local notif = widgets.popup({
		title = "Notification Center",
		on_close = function()
			awesome.emit_signal("popup::notif::hidden")
		end,
	})

	awesome.connect_signal("popup::notif::toggle", function()
		notif.visible = not notif.visible
	end)

	awesome.connect_signal("popup::notif::hidden", function()
		notif.visible = false
	end)

	return notif
end
