local awful = require("awful")
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
	local tooltip = helpers.ui.add_tooltip(ethernet, "Ethernet")

	awful.widget.watch([[sh -c "nmcli g | tail -n 1 | awk '{print $1}'"]], 15, function(_, stdout)
		local net_ssid = helpers.misc.trim(stdout)
		if net_ssid:match("connected") then
			ethernet:set_text("")
			ethernet:set_color(beautiful.fg)
			awful.spawn.easy_async_with_shell([[nmcli d | grep 'ethernet' | awk '{print $1}']], function(raw_device)
				local device = helpers.misc.trim(raw_device)
				awful.spawn.easy_async_with_shell(
					[[ip addr show ]] .. device .. [[ | grep 'inet\b' | awk '{print $2}' | cut -d/ -f1]],
					function(raw_ip)
						local ip = helpers.misc.trim(raw_ip)
						tooltip:set_text("Device: " .. device .. " - IP Addr: " .. ip)
					end
				)
			end)
		else
			ethernet:set_text("")
			ethernet:set_color(beautiful.black)
			tooltip:set_text("Ethernet: Disconnected")
		end

		collectgarbage("collect")
	end)

	return ethernet
end
