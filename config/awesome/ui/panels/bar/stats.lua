local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local apps = require("configs.apps")
local widgets = require("ui.widgets")
local helpers = require("helpers")
local wibox = require("wibox")

-- Stats Widget
--- CPU
local function cpu()
	local arc = wibox.widget({
		min_value = 0,
		max_value = 100,
		value = 50,
		start_angle = math.pi + math.pi / 2,
		bg = beautiful.bg3,
		colors = { beautiful.color2 },
		forced_width = dpi(24),
		forced_height = dpi(24),
		widget = wibox.container.arcchart,
	})

	local widget = wibox.widget({
		arc,
		{
			{
				markup = "<span foreground='" .. beautiful.color2 .. "'></span>",
				font = beautiful.icon_font .. " Round 10",
				widget = wibox.widget.textbox,
			},
			halign = "center",
			valign = "center",
			widget = wibox.container.place,
		},
		layout = wibox.layout.stack,
	})

	local tooltip = helpers.ui.add_tooltip(widget, "CPU Usage")

	awful.widget.watch(
		[[sh -c "
		vmstat 1 2 | tail -1 | awk '{printf \"%d\", $15}'
		"]],
		5,
		function(_, stdout)
			local cpu_idle = stdout
			cpu_idle = string.gsub(cpu_idle, "^%s*(.-)%s*$", "%1")

			local cpu_value = 100 - tonumber(cpu_idle)

			arc:set_value(cpu_value)
			tooltip:set_text("CPU Usage: " .. cpu_value .. "%")

			collectgarbage("collect")
		end
	)

	return widget
end

--- Memory
local function mem()
	local arc = wibox.widget({
		min_value = 0,
		max_value = 100,
		value = 50,
		start_angle = math.pi + math.pi / 2,
		bg = beautiful.bg3,
		colors = { beautiful.color4 },
		forced_width = dpi(24),
		forced_height = dpi(24),
		widget = wibox.container.arcchart,
	})

	local widget = wibox.widget({
		arc,
		{
			{
				markup = "<span foreground='" .. beautiful.color4 .. "'></span>",
				font = beautiful.icon_font .. " Round 10",
				widget = wibox.widget.textbox,
			},
			halign = "center",
			valign = "center",
			widget = wibox.container.place,
		},
		layout = wibox.layout.stack,
	})

	local tooltip = helpers.ui.add_tooltip(widget, "Memory Usage")

	awful.widget.watch(
		[[sh -c "
		free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
		"]],
		5,
		function(_, stdout)
			local available = stdout:match("(.*)@@")
			local total = stdout:match("@@(.*)@")
			local used = tonumber(total, 10) - tonumber(available, 10)

			local used_ram_percentage = (used / total) * 100

			arc:set_value(used_ram_percentage)
			tooltip:set_text(
				"Memory Usage: "
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
	local arc = wibox.widget({
		min_value = 0,
		max_value = 100,
		value = 50,
		start_angle = math.pi + math.pi / 2,
		bg = beautiful.bg3,
		colors = { beautiful.color3 },
		forced_width = dpi(24),
		forced_height = dpi(24),
		widget = wibox.container.arcchart,
	})

	local widget = wibox.widget({
		arc,
		{
			{
				markup = "<span foreground='" .. beautiful.color3 .. "'></span>",
				font = beautiful.icon_font .. " Round 10",
				widget = wibox.widget.textbox,
			},
			halign = "center",
			valign = "center",
			widget = wibox.container.place,
		},
		layout = wibox.layout.stack,
	})

	local tooltip = helpers.ui.add_tooltip(widget, "Temperature")

	awful.widget.watch([[sh -c "sensors" | grep "^edge"]], 15, function(_, stdout)
		local value = stdout:match("+(%d+)")

		arc:set_value(value)
		tooltip:set_text("Temperature: " .. value .. "°C")
		collectgarbage("collect")
	end)

	return widget
end

--- Disk
local function disk()
	local arc = wibox.widget({
		min_value = 0,
		max_value = 100,
		value = 50,
		start_angle = math.pi + math.pi / 2,
		bg = beautiful.bg3,
		colors = { beautiful.color5 },
		forced_width = dpi(24),
		forced_height = dpi(24),
		widget = wibox.container.arcchart,
	})

	local widget = wibox.widget({
		arc,
		{
			{
				markup = "<span foreground='" .. beautiful.color5 .. "'></span>",
				font = beautiful.icon_font .. " Round 10",
				widget = wibox.widget.textbox,
			},
			halign = "center",
			valign = "center",
			widget = wibox.container.place,
		},
		layout = wibox.layout.stack,
	})

	local tooltip = helpers.ui.add_tooltip(widget, "Disk Usage")

	awful.widget.watch([[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]], 180, function(_, stdout)
		local space_consumed = stdout:match("(%d+)")

		arc:set_value(tonumber(space_consumed))
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
