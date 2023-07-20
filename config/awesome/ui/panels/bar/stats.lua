local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local widgets = require("ui.widgets")
local helpers = require("helpers")

-- Stats Widget
--- CPU
local function cpu()
	local text = wibox.widget({
		{
			markup = "<span foreground='" .. beautiful.color2 .. "'></span>",
			font = beautiful.icon_font .. " Round 10",
			widget = wibox.widget.textbox,
		},
		halign = "center",
		valign = "center",
		widget = wibox.container.place,
	})

	local widget = wibox.widget({
		text,
		min_value = 0,
		max_value = 100,
		value = 100,
		thickness = dpi(4),
		start_angle = math.pi + math.pi / 2,
		bg = beautiful.black,
		colors = { beautiful.color2 },
		rounded_edge = true,
		forced_width = dpi(24),
		forced_height = dpi(24),
		widget = wibox.container.arcchart,
	})
	local tooltip = helpers.ui.add_tooltip(widget, "CPU Usage")

	awful.widget.watch(
		[[sh -c "
		vmstat 1 2 | tail -1 | awk '{printf \"%d\", $15}'
		"]],
		10,
		function(_, stdout)
			local cpu_idle = stdout
			cpu_idle = string.gsub(cpu_idle, "^%s*(.-)%s*$", "%1")

			local cpu_value = 100 - tonumber(cpu_idle, 10)

			widget:set_value(cpu_value)
			tooltip:set_text("CPU Usage: " .. cpu_value .. "%")

			collectgarbage("collect")
		end
	)

	return widget
end

--- Memory
local function mem()
	local text = wibox.widget({
		{
			markup = "<span foreground='" .. beautiful.color4 .. "'></span>",
			font = beautiful.icon_font .. " Round 10",
			widget = wibox.widget.textbox,
		},
		halign = "center",
		valign = "center",
		widget = wibox.container.place,
	})

	local widget = wibox.widget({
		text,
		min_value = 0,
		max_value = 100,
		value = 100,
		thickness = dpi(4),
		start_angle = math.pi + math.pi / 2,
		bg = beautiful.black,
		colors = { beautiful.color4 },
		rounded_edge = true,
		forced_width = dpi(24),
		forced_height = dpi(24),
		widget = wibox.container.arcchart,
	})
	local tooltip = helpers.ui.add_tooltip(widget, "Memory Usage")

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

			widget:set_value(used_ram_percentage)
			tooltip:set_text(
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
	local text = wibox.widget({
		{
			markup = "<span foreground='" .. beautiful.color3 .. "'></span>",
			font = beautiful.icon_font .. " Round 10",
			widget = wibox.widget.textbox,
		},
		halign = "center",
		valign = "center",
		widget = wibox.container.place,
	})

	local widget = wibox.widget({
		text,
		min_value = 0,
		max_value = 100,
		value = 100,
		thickness = dpi(4),
		start_angle = math.pi + math.pi / 2,
		bg = beautiful.black,
		colors = { beautiful.color3 },
		rounded_edge = true,
		forced_width = dpi(24),
		forced_height = dpi(24),
		widget = wibox.container.arcchart,
	})
	local tooltip = helpers.ui.add_tooltip(widget, "Temperature")

	awful.widget.watch([[sh -c "sensors" | grep "^edge"]], 15, function(_, stdout)
		local value = tonumber(stdout:match("+(%d+)"), 10)

		widget:set_value(value)
		tooltip:set_text("Temperature: " .. value .. "°C - Feeling: " .. (value > 60 and "󰈸 " or "󰜗 "))
		collectgarbage("collect")
	end)

	return widget
end

--- Disk
local function disk()
	local text = wibox.widget({
		{
			markup = "<span foreground='" .. beautiful.color5 .. "'></span>",
			font = beautiful.icon_font .. " Round 10",
			widget = wibox.widget.textbox,
		},
		halign = "center",
		valign = "center",
		widget = wibox.container.place,
	})

	local widget = wibox.widget({
		text,
		min_value = 0,
		max_value = 100,
		value = 100,
		thickness = dpi(4),
		start_angle = math.pi + math.pi / 2,
		bg = beautiful.black,
		colors = { beautiful.color5 },
		rounded_edge = true,
		forced_width = dpi(24),
		forced_height = dpi(24),
		widget = wibox.container.arcchart,
	})
	local tooltip = helpers.ui.add_tooltip(widget, "Disk Usage")

	awful.widget.watch([[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]], 180, function(_, stdout)
		local space_consumed = tonumber(stdout:match("(%d+)"), 10)

		widget:set_value(space_consumed)
		tooltip:set_text("Disk Usage: " .. space_consumed .. "%")
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
