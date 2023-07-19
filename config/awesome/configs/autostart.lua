local awful = require("awful")
local filesystem = require("gears.filesystem")
local apps = require("configs.apps")
local config_dir = filesystem.get_configuration_dir()
local helpers = require("helpers")

local function autostart()
	--- Compositor
	helpers.run.check_if_running("picom", nil, function()
		awful.spawn("picom --experimental-backends --config " .. config_dir .. "configs/picom.conf", false)
	end)
	--- Polkit Agent
	helpers.run.run_once_ps("polkit-kde-authentication-agent-1", "/usr/lib/polkit-kde-authentication-agent-1")
	-- Screen
	helpers.run.run_once_grep("xset s off")
	helpers.run.run_once_grep("xset s noblank")
	helpers.run.run_once_grep("xset -dpms")
	-- Inputs
	helpers.run.run_once_grep("xset r rate 400 50")
	--- Other stuff
	helpers.run.run_once_grep("blueman-applet")
	helpers.run.run_once_grep("nm-applet")
	-- Idle manager
	helpers.run.run_once_grep(apps.utils.idle .. " on")
end

autostart()
