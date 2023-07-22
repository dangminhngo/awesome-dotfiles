local awful = require("awful")
local beautiful = require("beautiful")
local apps = require("configs.apps")
local widgets = require("ui.widgets")
local helpers = require("helpers")

-- Volume Widget

return function()
	local volume = widgets.button.text.state({
		text_normal_bg = beautiful.black,
		text_on_normal_bg = beautiful.fg,
		normal_bg = beautiful.wibar_bg,
		font = beautiful.icon_font .. " Round ",
		size = 18,
		text = "",
		animate_size = false,
		on_release = function()
			awesome.emit_signal("popup::volume::toggle")
		end,
		on_secondary_release = function()
			awful.spawn(apps.default.sound_control, false)
		end,
	})

	awful.widget.watch([[sh -c "pamixer --get-volume"]], 10, function(_, stdout)
		local value = tonumber(helpers.misc.trim(stdout), 10)
		awesome.emit_signal("popup::volume::change", value)
		if value == nil then
			return
		end
		awful.spawn.easy_async_with_shell([[sh -c "pamixer --get-mute"]], function(out)
			local is_mute = helpers.misc.trim(out)
			awesome.emit_signal("popup::volume::mute", is_mute == "true" and true or false)
			if is_mute == "true" then
				volume:set_text("")
				volume:turn_off()
				volume:set_tooltip_text("Awkward silent")
			else
				volume:turn_on()
				if value == 0 then
					volume:set_text("")
				elseif value <= 50 then
					volume:set_text("")
				else
					volume:set_text("")
				end

				volume:set_tooltip_text("Volume: " .. value .. "%")
			end
		end)

		awesome.connect_signal("volume::mute", function(is_mute)
			if is_mute then
				volume:turn_off()
				volume:set_text("")
				volume:set_tooltip_text("Awkward silent")
			else
				volume:turn_on()
				volume:set_text("")
				volume:set_tooltip_text("Volume: Reading value")
			end
		end)

		collectgarbage("collect")
	end)

	return volume
end
