local awful = require("awful")
local beautiful = require("beautiful")
local apps = require("configs.apps")
local widgets = require("ui.widgets")

-- Power Widget

return function()
	local power = widgets.button.text.normal({
		text_normal_bg = beautiful.red,
		normal_bg = beautiful.wibar_bg,
		font = beautiful.icon_font .. " Round ",
		size = 16,
		text = "",
		tooltip = "Power",
		animate_size = false,
		on_release = function()
			awful.spawn(apps.utils.exit, false)
		end,
	})

	return power
end
