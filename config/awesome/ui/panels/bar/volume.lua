local awful = require("awful")
local beautiful = require("beautiful")
local apps = require("configs.apps")
local widgets = require("ui.widgets")
local helpers = require("helpers")

-- Volume Widget

return function()
	local volume = widgets.button.text.state({
		text_normal_bg = beautiful.fg,
		normal_bg = beautiful.wibar_bg,
		font = beautiful.icon_font .. " Round ",
		size = 18,
		text = "",
		on_release = function()
			awful.spawn(apps.default.sound_control, false)
		end,
		on_scroll_up = function()
			awful.spawn.with_shell([[sh -c "pamixer -i 10"]])
		end,
		on_scroll_down = function()
			awful.spawn.with_shell([[sh -c "pamixer -d 10"]])
		end,
	})
	local tooltip = helpers.ui.add_tooltip(volume, "Volume")

	awful.widget.watch([[sh -c "pamixer --get-volume"]], 10, function(_, stdout)
		local value = tonumber(helpers.misc.trim(stdout), 10)
		awful.spawn.easy_async_with_shell([[sh -c "pamixer --get-mute"]], function(out)
			local is_mute = helpers.misc.trim(out)
			if is_mute == "true" then
				volume:set_text("")
				volume:set_color(beautiful.black)
				tooltip:set_text("Awkward silent")
			else
				if value == 0 then
					volume:set_text("")
					volume:set_color(beautiful.fg)
				elseif value <= 50 then
					volume:set_text("")
					volume:set_color(beautiful.fg)
				else
					volume:set_text("")
					volume:set_color(beautiful.fg)
				end

				tooltip:set_text("Volume: " .. value .. "%")
			end
		end)

		collectgarbage("collect")
	end)

	return volume
end
