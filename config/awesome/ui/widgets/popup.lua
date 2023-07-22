local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local tbutton = require("ui.widgets.button.text")
local dpi = beautiful.xresources.apply_dpi

local popup = { mt = {} }

local function new(args)
	args = args or {}
	args.screen = args.screen or screen.focused
	args.title = args.title or "Popup"
	args.minimum_width = args.minimum_width or dpi(320)
	args.minimum_height = args.minimum_height or dpi(60)
	args.width = args.width or nil
	args.height = args.height or nil
	args.maximum_width = args.maximum_width or nil
	args.maximum_height = args.maximum_height or nil
	args.fg = args.fg or beautiful.fg
	args.bg = args.bg or beautiful.dark
	args.border_width = args.border_width or dpi(0)
	args.border_color = args.border_color or beautiful.accent
	args.visible = args.visible or false
	args.placement = args.placement
		or function(w)
			awful.placement.bottom_right(w, { honor_workarea = true, margins = { right = dpi(12), bottom = dpi(12) } })
		end
	args.on_close = args.on_close or nil
	args.child = args.child or nil

	local close = tbutton.normal({
		text_normal_bg = beautiful.accent,
		paddings = dpi(2),
		text = "",
		tooltip = "Close",
		font = beautiful.icon_font .. " Round ",
		size = 8,
		animate_size = false,
		forced_width = dpi(20),
		forced_height = dpi(20),
		normal_shape = gears.shape.circle,
		on_release = function()
			if args.on_close ~= nil then
				args.on_close()
			end
		end,
	})

	local titlebar = wibox.widget({
		{
			{
				{
					id = "title",
					text = args.title,
					font = beautiful.font .. " Bold 11",
					widget = wibox.widget.textbox,
				},
				nil,
				close,
				layout = wibox.layout.align.horizontal,
			},
			left = dpi(12),
			right = dpi(12),
			top = dpi(6),
			bottom = dpi(6),
			widget = wibox.container.margin,
		},
		bg = beautiful.bg0,
		widget = wibox.container.background,
	})

	local pu = awful.popup({
		widget = {
			titlebar,
			args.child,
			layout = wibox.layout.fixed.vertical,
		},
		screen = args.screen,
		minimum_width = args.minimum_width,
		minimum_height = args.minimum_height,
		maximum_width = args.maximum_width,
		maximum_height = args.maximum_height,
		width = args.width,
		height = args.height,
		fg = args.fg,
		bg = args.bg,
		border_width = args.border_width,
		border_color = args.border_color,
		visible = args.visible,
		shape = helpers.ui.rrect(dpi(4)),
		type = "dialog",
		ontop = true,
		placement = args.placement,
	})

	return pu
end

function popup.mt:__call(...)
	return new(...)
end

return setmetatable(popup, popup.mt)
