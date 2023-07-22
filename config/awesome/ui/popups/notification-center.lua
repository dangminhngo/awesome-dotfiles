local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local widgets = require("ui.widgets")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local function removeNotifById(t, id)
	for k, v in ipairs(t) do
		if v.id == id then
			table.remove(t, k)
			return
		end
	end
end

local function getWidgetIndexByNotifId(id)
	for k, v in ipairs(_G.notifications) do
		if v.id == id then
			return k
		end
	end

	return 0
end

return function()
	local workarea_height = awful.screen.focused().workarea.height

	local notif_list = wibox.widget({
		spacing = dpi(8),
		forced_height = dpi(920),
		layout = wibox.layout.fixed.vertical,
	})

	local MAX_WIDGET_NUM = 6

	local function render_notif_list()
		notif_list:reset()
		for i = 1, MAX_WIDGET_NUM do
			local n = _G.notifications[i]
			local card = widgets.notification.card(n)
			notif_list:add(card)
		end
	end

	local clear = widgets.button.text.normal({
		text = "CLEAR ALL",
		text_normal_bg = beautiful.fg,
		font = beautiful.font .. " Bold ",
		size = 11,
		paddings = dpi(6),
		animate_false = false,
		normal_border_width = dpi(2),
		normal_border_color = beautiful.accent,
		normal_bg = beautiful.transparent,
		normal_shape = helpers.ui.rrect(dpi(6)),
		on_by_default = #_G.notifications > 0,
		animate_size = false,
		on_release = function(self)
			if #_G.notifications > 0 then
				_G.notifications = {}
				self:set_text("CLEAR ALL")
				notif_list:reset()
			end
		end,
	})

	local toggle_dnd = widgets.button.text.normal({
		text = "DO NOT DISTURB: OFF",
		text_normal_bg = beautiful.fg,
		font = beautiful.font .. " Bold ",
		size = 11,
		paddings = dpi(6),
		animate_false = false,
		normal_bg = beautiful.bg0,
		normal_shape = helpers.ui.rrect(dpi(6)),
		on_by_default = #_G.notifications > 0,
		animate_size = false,
		on_release = function()
			naughty.suspended = not naughty.suspended
			awesome.emit_signal("notification-center::toggle_dnd")
		end,
	})

	awesome.connect_signal("notification-center::toggle_dnd", function()
		local dnd_state = naughty.suspended and "ON" or "OFF"
		toggle_dnd:set_text("DO NOT DISTURB: " .. dnd_state)
	end)

	local notif = widgets.popup({
		child = {
			nil,
			notif_list,
			{
				clear,
				toggle_dnd,
				spacing = dpi(12),
				layout = wibox.layout.flex.horizontal,
			},
			layout = wibox.layout.align.vertical,
		},
		title = "Notification Center",
		minimum_height = workarea_height - beautiful.useless_gap * 2 - dpi(52),
		minimum_width = dpi(400),
		width = dpi(400),
		bg = beautiful.bg,
		on_close = function()
			awesome.emit_signal("popup::notif::hidden")
		end,
	})

	local step = 0
	-- Make notification list scrollable
	notif_list:buttons(gears.table.join(
		awful.button({}, 4, nil, function()
			if #_G.notifications <= MAX_WIDGET_NUM or step <= 0 then
				return
			end
			step = math.max(0, step - 1)
			local new_child = widgets.notification.card(_G.notifications[step + 1])
			notif_list:remove(MAX_WIDGET_NUM)
			notif_list:insert(1, new_child)
		end),
		awful.button({}, 5, nil, function()
			if #_G.notifications <= MAX_WIDGET_NUM or step >= #_G.notifications - MAX_WIDGET_NUM then
				return
			end

			step = math.min(#_G.notifications - MAX_WIDGET_NUM, step + 1)
			local new_child = widgets.notification.card(_G.notifications[#_G.notifications - MAX_WIDGET_NUM + 2 + step])
			notif_list:remove(1)
			notif_list:insert(MAX_WIDGET_NUM, new_child)
		end)
	))

	awesome.connect_signal("popup::notif::toggle", function()
		notif.visible = not notif.visible

		if notif.visible then
			render_notif_list()
			clear:set_text("CLEAR ALL (" .. #_G.notifications .. ")")
			local dnd_state = naughty.suspended and "ON" or "OFF"
			toggle_dnd:set_text("DO NOT DISTURB: " .. dnd_state)
		end
	end)

	awesome.connect_signal("popup::notif::hidden", function()
		notif.visible = false
	end)

	awesome.connect_signal("notification-center::remove", function(id)
		-- Place this line before removing notif item from the list
		local index = getWidgetIndexByNotifId(id)
		removeNotifById(_G.notifications, id)
		if index > 0 then
			notif_list:remove(index)
		end
		render_notif_list()
	end)

	return notif
end
