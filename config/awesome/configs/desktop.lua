local awful = require("awful")
require("awful.autofocus")
local gears = require("gears")
local beautiful = require("beautiful")

client.connect_signal("request::manage", function(c)
	--- Add missing icon to client
	if not c.icon then
		local icon = gears.surface(beautiful.theme_assets.awesome_icon(24, beautiful.color8, beautiful.black))
		c.icon = icon._native
		icon:finish()
	end

	--- Set the windows at the slave,
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		--- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

--- Hide all windows when a splash is shown
awesome.connect_signal("widgets::splash::visibility", function(vis)
	local t = screen.primary.selected_tag
	if vis then
		for idx, c in ipairs(t:clients()) do
			c.hidden = true
		end
	else
		for idx, c in ipairs(t:clients()) do
			c.hidden = false
		end
	end
end)

--- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

--- Wallpapers
--- ~~~~~~~~~-
--- Change wallpaper after every 30 mins
gears.timer({
	timeout = 60 * 30,
	call_now = true,
	autostart = true,
	callback = function()
		awful.screen.connect_for_each_screen(function(s)
			if beautiful.wallpaper then
				local wallpaper = beautiful.random_wallpaper()

				if type(wallpaper) == "function" then
					wallpaper = wallpaper(s)
				end

				gears.wallpaper.maximized(wallpaper, s, false, nil)
			end
		end)
	end,
})
