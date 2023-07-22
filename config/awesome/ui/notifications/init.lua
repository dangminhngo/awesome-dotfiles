local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")
local helpers = require("helpers")
local menubar = require("menubar")
local widgets = require("ui.widgets")

--- Naughty Notifications with animation
--- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

naughty.persistence_enabled = true
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 10
naughty.config.defaults.title = "System"
naughty.config.defaults.position = "bottom_right"
naughty.config.spacing = dpi(6)

local function get_oldest_notification()
	for _, notification in ipairs(naughty.active) do
		if notification and notification.timeout > 0 then
			return notification
		end
	end

	--- Fallback to first one.
	return naughty.active[1]
end

_G.notifications = {}

--- Add notification to the list
naughty.connect_signal("added", function(n)
	n.timestamp = helpers.misc.timestamp()
	table.insert(_G.notifications, 1, n)
end)

--- Handle notification icon
naughty.connect_signal("request::icon", function(n, context, hints)
	--- Handle other contexts here
	if context ~= "app_icon" then
		return
	end

	--- Use XDG icon
	local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

	if path then
		n.icon = path
	end
end)

--- Use XDG icon
naughty.connect_signal("request::action_icon", function(a, context, hints)
	a.icon = menubar.utils.lookup_icon(hints.id)
end)

naughty.connect_signal("request::display", function(n)
	local notif_widget = widgets.notification.popup(n)
	local widget = naughty.layout.box({
		notification = n,
		type = "notification",
		cursor = "hand2",
		--- For antialiasing: The real shape is set in widget_template
		shape = gears.shape.rectangle,
		maximum_width = dpi(440),
		maximum_height = dpi(180),
		minimum_width = dpi(400),
		minimum_height = dpi(120),
		bg = "#00000000",
		widget_template = notif_widget,
	})

	--- Don't destroy the notification on click
	widget.buttons = {}

	local notification_height = widget.height + beautiful.notification_spacing
	local total_notifications_height = #naughty.active * notification_height

	if total_notifications_height > n.screen.workarea.height then
		get_oldest_notification():destroy(naughty.notification_closed_reason.too_many_on_screen)
	end
end)

-- -- Uncomment this for testing notifications
-- for i = 1, 10 do
-- 	naughty.notification({
-- 		title = "Notif " .. i,
-- 		message = "I am the message for you",
-- 		app_name = "Screenshot",
-- 		timeout = 100,
-- 		actions = {
-- 			naughty.action({
-- 				name = "Accept",
-- 			}),
-- 			naughty.action({
-- 				name = "Refuse",
-- 			}),
-- 			naughty.action({
-- 				name = "Ignore",
-- 			}),
-- 		},
-- 	})
-- end
