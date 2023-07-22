local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local widgets = require("ui.widgets")
local dpi = beautiful.xresources.apply_dpi

return function()
	local volume = widgets.popup({
		title = "Volume Control",
		on_close = function()
			awesome.emit_signal("popup::volume::hidden")
		end,
	})

	awesome.connect_signal("popup::volume::visible", function()
		volume.visible = true
	end)

	awesome.connect_signal("popup::volume::hidden", function()
		volume.visible = false
	end)

	return volume
end
