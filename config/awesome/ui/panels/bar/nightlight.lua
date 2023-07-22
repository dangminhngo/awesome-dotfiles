local awful = require("awful")
local beautiful = require("beautiful")
local widgets = require("ui.widgets")
local apps = require("configs.apps")

-- Nightlight Widget
return function()
	local nightlight = widgets.button.text.state({
		text_normal_bg = beautiful.black,
		text_on_normal_bg = beautiful.fg,
		normal_bg = beautiful.wibar_bg,
		font = beautiful.icon_font .. " Round ",
		size = 16,
		text = "",
		tooltip = "Nightlight: OFF",
		on_by_default = false,
		animate_size = false,
		on_turn_on = function(self)
			awful.spawn.with_shell(apps.utils.nightlight .. " on")
			self:set_text("")
			self:set_tooltip_text("Nightlight: ON")
		end,
		on_turn_off = function(self)
			awful.spawn.with_shell(apps.utils.nightlight .. " off")
			self:set_text("")
			self:set_tooltip_text("Nightlight: OFF")
		end,
	})

	return nightlight
end
