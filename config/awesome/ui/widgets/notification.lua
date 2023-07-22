local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local tbutton = require("ui.widgets.button.text")
local twidget = require("ui.widgets.text")
local animation = require("modules.animation")

local notif = { mt = {} }

--- table of icons
local app_icons = {
	["firefox"] = { icon = "" },
	["discord"] = { icon = "" },
	["music"] = { icon = "" },
	["Screenshot"] = { icon = "" },
	["Color Picker"] = { icon = "" },
}

function notif.popup(n)
	local app_icon = nil
	local tolow = string.lower

	if app_icons[tolow(n.app_name)] then
		app_icon = app_icons[tolow(n.app_name)].icon
	else
		app_icon = ""
	end

	local app_icon_n = wibox.widget({
		{
			font = beautiful.icon_font .. "Round 10",
			markup = "<span foreground='" .. beautiful.notification_bg .. "'>" .. app_icon .. "</span>",
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
		bg = beautiful.accent,
		widget = wibox.container.background,
		shape = gears.shape.circle,
		forced_height = dpi(20),
		forced_width = dpi(20),
	})

	local icon = wibox.widget({
		{
			{
				{
					image = n.icon,
					resize = true,
					clip_shape = gears.shape.circle,
					halign = "center",
					valign = "center",
					widget = wibox.widget.imagebox,
				},
				border_width = dpi(2),
				border_color = beautiful.accent,
				shape = gears.shape.circle,
				widget = wibox.container.background,
			},
			strategy = "exact",
			height = dpi(36),
			width = dpi(36),
			widget = wibox.container.constraint,
		},
		{
			nil,
			nil,
			{
				nil,
				nil,
				app_icon_n,
				layout = wibox.layout.align.horizontal,
				expand = "none",
			},
			layout = wibox.layout.align.vertical,
			expand = "none",
		},
		layout = wibox.layout.stack,
	})

	local app_name = twidget({
		size = 8,
		text = n.app_name:gsub("^%l", string.upper),
	})

	local dismiss = tbutton.normal({
		font = beautiful.icon_font .. " Round ",
		paddings = dpi(2),
		size = 8,
		bold = true,
		text = "",
		text_normal_bg = beautiful.fg,
		tooltip = "Dismiss",
		animate_size = false,
		on_release = function()
			n:destroy(naughty.notification_closed_reason.dismissed_by_user)
		end,
	})

	local timeout_arc = wibox.widget({
		widget = wibox.container.arcchart,
		forced_width = dpi(24),
		forced_height = dpi(24),
		max_value = 100,
		min_value = 0,
		value = 0,
		thickness = dpi(4),
		rounded_edge = true,
		bg = beautiful.notification_bg,
		colors = {
			{
				type = "linear",
				from = { 0, 0 },
				to = { 400, 400 },
				stops = {
					{ 0, beautiful.accent },
					{ 0.2, beautiful.blue },
					{ 0.4, beautiful.yellow },
					{ 0.6, beautiful.orange },
					{ 0.8, beautiful.red },
				},
			},
		},
		dismiss,
	})

	local title = wibox.widget({
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		fps = 60,
		speed = 75,
		twidget({
			font = beautiful.font_name,
			bold = true,
			size = 11,
			text = n.title,
		}),
	})

	local message = wibox.widget({
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		fps = 60,
		speed = 75,
		twidget({
			font = beautiful.font_name,
			size = 11,
			text = n.message,
		}),
	})

	local actions = wibox.widget({
		notification = n,
		base_layout = wibox.widget({
			spacing = dpi(6),
			layout = wibox.layout.flex.horizontal,
		}),
		widget_template = {
			{
				{
					{
						id = "text_role",
						font = beautiful.notification_font,
						widget = wibox.widget.textbox,
					},
					left = dpi(6),
					right = dpi(6),
					widget = wibox.container.margin,
				},
				widget = wibox.container.place,
			},
			bg = beautiful.bg0,
			forced_height = dpi(28),
			forced_width = dpi(70),
			shape = helpers.ui.rrect(dpi(4)),
			widget = wibox.container.background,
		},
		style = {
			underline_normal = false,
			underline_selected = true,
		},
		widget = naughty.list.actions,
	})

	local widget = wibox.widget({
		{
			layout = wibox.layout.fixed.vertical,
			{
				{
					{
						layout = wibox.layout.align.horizontal,
						app_name,
						nil,
						timeout_arc,
					},
					margins = { top = dpi(2), bottom = dpi(2), left = dpi(12), right = dpi(12) },
					widget = wibox.container.margin,
				},
				bg = beautiful.notification_bg_alt,
				widget = wibox.container.background,
			},
			{
				{
					layout = wibox.layout.fixed.vertical,
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(12),
						icon,
						{
							expand = "none",
							layout = wibox.layout.align.vertical,
							nil,
							{
								layout = wibox.layout.fixed.vertical,
								title,
								message,
							},
							nil,
						},
					},
					{
						helpers.ui.vertical_pad(dpi(12)),
						{
							actions,
							shape = helpers.ui.rrect(beautiful.border_radius / 2),
							widget = wibox.container.background,
						},
						visible = n.actions and #n.actions > 0,
						layout = wibox.layout.fixed.vertical,
					},
				},
				margins = dpi(12),
				widget = wibox.container.margin,
			},
		},
		--- Anti-aliasing container
		shape = helpers.ui.rrect(beautiful.border_radius),
		bg = beautiful.notification_bg,
		widget = wibox.container.background,
	})

	local anim = animation:new({
		duration = n.timeout,
		target = 100,
		easing = animation.easing.linear,
		reset_on_stop = false,
		update = function(_, pos)
			timeout_arc.value = pos
		end,
	})

	anim:connect_signal("ended", function()
		n:destroy()
	end)

	widget:connect_signal("mouse::enter", function()
		--- Absurdly big number because setting it to 0 doesn't work
		n:set_timeout(4294967)
		anim:stop()
	end)

	widget:connect_signal("mouse::leave", function()
		anim:start()
	end)

	anim:start()

	return widget
end

function notif.card(n)
	local app_icon = nil
	local tolow = string.lower

	if app_icons[tolow(n.app_name)] then
		app_icon = app_icons[tolow(n.app_name)].icon
	else
		app_icon = ""
	end

	local app_icon_n = wibox.widget({
		{
			font = beautiful.icon_font .. "Round 10",
			markup = "<span foreground='" .. beautiful.notification_bg .. "'>" .. app_icon .. "</span>",
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
		bg = beautiful.accent,
		widget = wibox.container.background,
		shape = gears.shape.circle,
		forced_height = dpi(20),
		forced_width = dpi(20),
	})

	local icon = wibox.widget({
		{
			{
				{
					image = n.icon,
					resize = true,
					clip_shape = gears.shape.circle,
					halign = "center",
					valign = "center",
					widget = wibox.widget.imagebox,
				},
				border_width = dpi(2),
				border_color = beautiful.accent,
				shape = gears.shape.circle,
				widget = wibox.container.background,
			},
			strategy = "exact",
			height = dpi(36),
			width = dpi(36),
			widget = wibox.container.constraint,
		},
		{
			nil,
			nil,
			{
				nil,
				nil,
				app_icon_n,
				layout = wibox.layout.align.horizontal,
				expand = "none",
			},
			layout = wibox.layout.align.vertical,
			expand = "none",
		},
		layout = wibox.layout.stack,
	})

	local app_name = twidget({
		size = 8,
		text = n.app_name:gsub("^%l", string.upper),
	})

	local time = helpers.misc.to_time_ago(os.time() - helpers.misc.parse_date(n.timestamp))
	local timestamp = twidget({
		size = 8,
		text = time,
		color = beautiful.gray,
	})

	local dismiss = tbutton.normal({
		font = beautiful.icon_font .. " Round ",
		paddings = dpi(2),
		size = 8,
		bold = true,
		text = "",
		text_normal_bg = beautiful.fg,
		tooltip = "Remove",
		animate_size = false,
		forced_width = dpi(18),
		forced_height = dpi(18),
		normal_shape = gears.shape.circle,
		on_release = function()
			awesome.emit_signal("notification-center::remove", n.id)
		end,
	})

	local title = wibox.widget({
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		fps = 60,
		speed = 75,
		twidget({
			font = beautiful.font_name,
			bold = true,
			size = 11,
			text = n.title,
		}),
	})

	local message = wibox.widget({
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		fps = 60,
		speed = 75,
		twidget({
			font = beautiful.font_name,
			size = 11,
			text = n.message,
		}),
	})

	local actions = wibox.widget({
		notification = n,
		base_layout = wibox.widget({
			spacing = dpi(6),
			layout = wibox.layout.flex.horizontal,
		}),
		widget_template = {
			{
				{
					{
						id = "text_role",
						font = beautiful.notification_font,
						widget = wibox.widget.textbox,
					},
					left = dpi(6),
					right = dpi(6),
					widget = wibox.container.margin,
				},
				widget = wibox.container.place,
			},
			bg = beautiful.bg0,
			forced_height = dpi(28),
			forced_width = dpi(70),
			shape = helpers.ui.rrect(dpi(4)),
			widget = wibox.container.background,
		},
		style = {
			underline_normal = false,
			underline_selected = true,
		},
		widget = naughty.list.actions,
	})

	local widget = wibox.widget({
		{
			layout = wibox.layout.fixed.vertical,
			{
				{
					{
						layout = wibox.layout.align.horizontal,
						app_name,
						{
							timestamp,
							left = dpi(12),
							widget = wibox.container.margin,
						},
						dismiss,
					},
					margins = { top = dpi(2), bottom = dpi(2), left = dpi(12), right = dpi(12) },
					widget = wibox.container.margin,
				},
				bg = beautiful.notification_bg_alt,
				widget = wibox.container.background,
			},
			{
				{
					layout = wibox.layout.fixed.vertical,
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(12),
						icon,
						{
							expand = "none",
							layout = wibox.layout.align.vertical,
							nil,
							{
								layout = wibox.layout.fixed.vertical,
								title,
								message,
							},
							nil,
						},
					},
					{
						helpers.ui.vertical_pad(dpi(12)),
						{
							actions,
							shape = helpers.ui.rrect(beautiful.border_radius / 2),
							widget = wibox.container.background,
						},
						visible = n.actions and #n.actions > 0,
						layout = wibox.layout.fixed.vertical,
					},
				},
				margins = dpi(12),
				widget = wibox.container.margin,
			},
		},
		--- Anti-aliasing container
		shape = helpers.ui.rrect(beautiful.border_radius),
		bg = beautiful.notification_bg,
		widget = wibox.container.background,
	})

	return widget
end

return setmetatable(notif, notif.mt)
