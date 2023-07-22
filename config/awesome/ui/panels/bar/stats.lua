local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local widgets = require("ui.widgets")
local helpers = require("helpers")

-- Stats Widget
--- CPU
local function cpu()
	local widget = widgets.statarc({
		text = "",
	})

	awful.widget.watch(
		[[sh -c "
		vmstat 1 2 | tail -1 | awk '{printf \"%d\", $15}'
		"]],
		10,
		function(_, stdout)
			local cpu_idle = stdout
			cpu_idle = string.gsub(cpu_idle, "^%s*(.-)%s*$", "%1")

			local cpu_value = 100 - tonumber(cpu_idle, 10)

			widget.value = cpu_value
			widget:set_tooltip_text("CPU Usage: " .. cpu_value .. "%")

			collectgarbage("collect")
		end
	)

	return widget
end

--- Memory
local function mem()
	local widget = widgets.statarc({
		text = "",
		fg = beautiful.color4,
	})

	awful.widget.watch(
		[[sh -c "
		free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
		"]],
		10,
		function(_, stdout)
			local available = stdout:match("(.*)@@")
			local total = stdout:match("@@(.*)@")
			local used = tonumber(total, 10) - tonumber(available, 10)

			local used_ram_percentage = (used / total) * 100

			widget.value = used_ram_percentage
			widget:set_tooltip_text(
				"Memory Usage: "
					.. string.format("%.0f", used_ram_percentage)
					.. "% - Used: "
					.. string.format("%.1f", used / 1024)
					.. "G/"
					.. string.format("%.1f", total / 1024)
					.. "G"
			)
			collectgarbage("collect")
		end
	)

	return widget
end

--- Temperature
local function temp()
	local widget = widgets.statarc({
		text = "",
		fg = beautiful.color3,
	})

	awful.widget.watch([[sh -c "sensors" | grep "^edge"]], 15, function(_, stdout)
		local value = tonumber(stdout:match("+(%d+)"), 10)

		widget.value = value
		widget:set_tooltip_text("Temperature: " .. value .. "°C - Feeling: " .. (value > 60 and "󰈸 " or "󰜗 "))
		collectgarbage("collect")
	end)

	return widget
end

--- Disk
local function disk()
	local widget = widgets.statarc({
		text = "",
		fg = beautiful.color5,
	})

	awful.widget.watch([[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]], 180, function(_, stdout)
		local space_consumed = tonumber(stdout:match("(%d+)"), 10)

		widget.value = space_consumed
		widget:set_tooltip_text("Disk Usage: " .. space_consumed .. "%")
		collectgarbage("collect")
	end)

	return widget
end

return function()
	local stats = wibox.widget({
		cpu(),
		mem(),
		temp(),
		disk(),
		spacing = dpi(12),
		layout = wibox.layout.fixed.horizontal,
	})

	return stats
end
