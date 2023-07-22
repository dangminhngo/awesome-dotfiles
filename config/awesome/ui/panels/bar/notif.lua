local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local helpers = require("helpers")
local widgets = require("ui.widgets")
local apps = require("configs.apps")
local dpi = beautiful.xresources.apply_dpi

_G.dnd_state = false

-- Notif Widget
return function()
	local num = wibox.widget({
		{
			{
				id = "num",
				font = beautiful.font .. " Bold 8",
				widget = wibox.widget.textbox,
			},
			top = dpi(4),
			widget = wibox.container.margin,
		},
		widget = wibox.container.place,
	})

	local notif = widgets.button.text.state({
		text_normal_bg = beautiful.black,
		text_on_normal_bg = beautiful.fg,
		normal_bg = beautiful.wibar_bg,
		font = beautiful.icon_font .. " Round ",
		size = 16,
		text = "",
		tooltip = "There is no notifications",
		animate_size = false,
		on_by_default = true,
		on_release = function()
			awesome.emit_signal("popup::notif::toggle")
		end,
		on_secondary_release = function(self)
			naughty.suspended = not naughty.suspended
			if naughty.suspended then
				self:turn_off()
				self:set_text("")
				num:get_children_by_id("num")[1]:set_text("")
				self:set_tooltip_text("Do not disturb")
			else
				self:turn_on()
				self:set_text("")
				self:set_tooltip_text("There is no notifications")
			end
		end,
	})

	local widget = wibox.widget({
		notif,
		num,
		layout = wibox.layout.stack,
	})

	local function get_tooltip(value)
		if value == 0 then
			return "There is no notifications"
		elseif value == 1 then
			return "There is one notification"
		else
			return "There are " .. value .. " notifications"
		end
	end

	naughty.connect_signal("added", function()
		if naughty.suspended then
			num:get_children_by_id("num")[1]:set_markup("")
		else
			local value = #naughty.active
			notif:turn_on()
			notif:set_color(beautiful.orange)
			notif:set_text("")
			notif:set_tooltip_text(get_tooltip(value))
			num:get_children_by_id("num")[1]:set_markup(helpers.ui.colorize_text(value, beautiful.bg0))
		end
	end)

	return widget
end
