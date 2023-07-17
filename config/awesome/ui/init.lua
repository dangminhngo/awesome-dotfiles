local awful = require("awful")

require("ui.notifications")
require("ui.popups")
local bar = require("ui.panels.bar")

awful.screen.connect_for_each_screen(function(s)
	--- Panels
	bar(s)
end)
