local awful = require("awful")
local beautiful = require("beautiful")
local widgets = require("ui.widgets")
local gfs = require("gears.filesystem")
local config_dir = gfs.get_configuration_dir()
local scripts_dir = config_dir .. "scripts/"

local _capture = {}

local capture = widgets.button.text.normal({
	text_normal_bg = beautiful.red,
	normal_bg = beautiful.wibar_bg,
	font = beautiful.icon_font .. " Round ",
	size = 16,
	text = "",
	tooltip = "Capturing! Click to stop",
	on_release = function(self)
		awful.spawn.with_shell(scripts_dir .. "screencapture stop")
		self:set_visible(false)
	end,
})

function _capture.indicate()
	capture:set_visible(true)
end

-- Capture Widget
function _capture.widget()
	capture:set_visible(false)
	return capture
end

return _capture
