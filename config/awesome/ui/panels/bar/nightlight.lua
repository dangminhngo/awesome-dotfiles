local awful = require("awful")
local beautiful = require("beautiful")
local widgets = require("ui.widgets")
local helpers = require("helpers")

-- Nightlight Widget
return function()
	local nightlight = widgets.button.text.state({
		text_normal_bg = beautiful.black,
		normal_bg = beautiful.wibar_bg,
		font = beautiful.icon_font .. " Round ",
		size = 16,
		text = "",
		on_release = function(self)
			local tooltip = helpers.ui.add_tooltip(self, "Nightlight: Off")
			awful.spawn.easy_async_with_shell([[~/.dotfiles/scripts/utils nightlight]], function(stdout)
				local state = helpers.misc.trim(stdout)
				if state == "on" then
					self:set_text("")
					self:set_color(beautiful.fg)
					tooltip:set_text("Nightlight: On")
				else
					self:set_text("")
					self:set_color(beautiful.black)
					tooltip:set_text("Nightlight: Off")
				end
			end)
		end,
	})

	return nightlight
end
