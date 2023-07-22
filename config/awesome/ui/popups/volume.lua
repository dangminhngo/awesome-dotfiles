local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local widgets = require("ui.widgets")
local dpi = beautiful.xresources.apply_dpi

return function()
	local icon = widgets.button.text.state({
		text = "",
		text_normal_bg = beautiful.accent,
		text_on_normal_bg = beautiful.accent,
		font = beautiful.icon_font .. " Round ",
		size = 16,
		paddings = { right = dpi(8) },
		on_by_default = true,
		normal_bg = beautiful.transparent,
		on_turn_on = function(self)
			awful.spawn.with_shell([[sh -c "pamixer -u"]])
			self:turn_on()
			self:set_text("")
			awesome.emit_signal("volume::mute", false)
		end,
		on_turn_off = function(self)
			awful.spawn.with_shell([[sh -c "pamixer -m"]])
			self:turn_off()
			self:set_text("")
			awesome.emit_signal("volume::mute", true)
		end,
	})

	local slider = wibox.widget({
		bar_shape = helpers.ui.rrect(dpi(6)),
		bar_height = dpi(4),
		bar_color = beautiful.black,
		bar_active_color = beautiful.accent,
		handle_color = beautiful.accent,
		handle_shape = gears.shape.circle,
		handle_width = dpi(16),
		value = 100,
		widget = wibox.widget.slider,
	})
	awful.spawn.easy_async_with_shell([[sh -c "pamixer --get-volume"]], function(stdout)
		local value = tonumber(helpers.misc.trim(stdout), 10)
		slider:set_value(value)
	end)

	local vol = wibox.widget({
		{
			id = "value",
			text = "100%",
			font = beautiful.font .. " Regular 11",
			widget = wibox.widget.textbox,
		},
		left = dpi(8),
		widget = wibox.container.margin,
	})

	local volume = widgets.popup({
		child = {
			icon,
			slider,
			vol,
			forced_width = dpi(320),
			forced_height = dpi(40),
			spacing = dpi(6),
			layout = wibox.layout.align.horizontal,
		},
		title = "Volume Control",
		on_close = function()
			awesome.emit_signal("popup::volume::hidden")
		end,
	})

	awesome.connect_signal("popup::volume::toggle", function()
		volume.visible = not volume.visible
	end)

	awesome.connect_signal("popup::volume::hidden", function()
		volume.visible = false
	end)

	slider:connect_signal("property::value", function(_, value)
		awful.spawn.easy_async_with_shell('sh -c "pamixer --set-volume ' .. value .. '"', function() end)
		vol:get_children_by_id("value")[1]:set_text(value .. "%")
	end)

	awesome.connect_signal("popup::volume::change", function(value)
		slider.value = value
		vol:get_children_by_id("value")[1]:set_text(value .. "%")
	end)

	awesome.connect_signal("popup::volume::mute", function(is_mute)
		if is_mute then
			icon:turn_off()
			icon:set_text("")
		else
			icon:turn_on()
			icon:set_text("")
		end
	end)

	return volume
end
