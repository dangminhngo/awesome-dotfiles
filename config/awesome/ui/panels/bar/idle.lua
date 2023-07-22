local awful = require("awful")
local beautiful = require("beautiful")
local widgets = require("ui.widgets")
local apps = require("configs.apps")

-- Idle Widget
return function()
	local idle = widgets.button.text.state({
		text_normal_bg = beautiful.black,
		text_on_normal_bg = beautiful.fg,
		normal_bg = beautiful.wibar_bg,
		font = beautiful.icon_font .. " Round ",
		size = 16,
		text = "",
		tooltip = "Idle Inhibit: OFF",
		on_by_default = false,
		animate_size = false,
		on_turn_on = function(self)
			awful.spawn.with_shell(apps.utils.idle .. " off")
			self:set_text("")
			self:set_tooltip_text("Idle Inhibit: ON")
		end,
		on_turn_off = function(self)
			awful.spawn.with_shell(apps.utils.idle .. " on")
			self:set_text("")
			self:set_tooltip_text("Idle Inhibit: OFF")
		end,
	})

	return idle
end
