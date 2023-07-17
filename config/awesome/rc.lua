pcall(require, "luarocks.loader")
local gears = require("gears")
local beautiful = require("beautiful")

-- THEME
local theme_dir = gears.filesystem.get_configuration_dir() .. "theme/"
beautiful.init(theme_dir .. "theme.lua")

-- CONFIGS
require("configs")

-- MODULES
require("modules")

-- UI
require("ui")

-- GARBAGE
--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		collectgarbage("collect")
	end,
})
