local awful = require("awful")
local naughty = require("naughty")
local helpers = require("helpers")
local C = require("modules.color")

local _xcolor = {}

function _xcolor.pick(mode)
	mode = mode or "hex"
	awful.spawn.easy_async_with_shell([[sh -c "gpick --no-newline -pso"]], function(stdout)
		local clr = C.color({ hex = helpers.misc.trim(stdout) })

		if mode == "hex" then
			awful.spawn.with_shell("printf %s '" .. clr.hex .. "' | xclip -selection clipboard")
			naughty.notification({
				title = "Color " .. clr.hex .. " copied to the system clipboard",
				app_name = "Color Picker",
			})
			return
		end

		if mode == "hsl" then
			local hsl = "hsl("
				.. helpers.misc.round(clr.h)
				.. ", "
				.. helpers.misc.round(clr.s)
				.. "%, "
				.. helpers.misc.round(clr.l)
				.. "%)"
			awful.spawn.with_shell("printf %s '" .. hsl .. "' | xclip -selection clipboard")
			naughty.notification({
				title = "Color " .. hsl .. " copied to the system clipboard",
				app_name = "Color Picker",
			})
			return
		end

		if mode == "rgb" then
			local rgb = "rgb(" .. clr.r .. ", " .. clr.g .. ", " .. clr.b .. ")"
			awful.spawn.with_shell("printf %s '" .. rgb .. "' | xclip -selection clipboard")
			naughty.notification({
				title = "Color " .. rgb .. " copied to the system clipboard",
				app_name = "Color Picker",
			})
		end
	end)
end

return _xcolor
