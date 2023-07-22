local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local theme = dofile(themes_path .. "default/theme.lua")
local theme_assets = require("beautiful.theme_assets")
local xrs = require("beautiful.xresources")
local dpi = xrs.apply_dpi
local helpers = require("helpers")
local icons = require("icons")
local palette = require("theme.palette")

-- FONTS
-- UI Fonts
theme.font_name = "Jetka"
theme.font = theme.font_name .. " Medium 11"
-- Icon Fonts
theme.icon_font = "Material Icons"

-- COLORS
theme.transparent = palette.transparent
theme.fg = palette.fg
theme.bg = palette.bg

-- Accent color
theme.accent = palette.accent
-- Backgrounds & Foregrounds
theme.dark = palette.dark
theme.bg0 = palette.bg0
theme.bg2 = palette.bg2
theme.bg3 = palette.bg3
theme.bg4 = palette.bg4
theme.fg0 = palette.fg0
theme.fg2 = palette.fg2
theme.fg3 = palette.fg3
theme.fg4 = palette.fg4
-- Palette
theme.red = palette.red
theme.green = palette.green
theme.yellow = palette.yellow
theme.blue = palette.blue
theme.magenta = palette.magenta
theme.cyan = palette.cyan
theme.teal = palette.teal
theme.orange = palette.orange
theme.pink = palette.pink
theme.black = palette.black
theme.gray = palette.gray
theme.white = palette.white

--- Black
theme.color0 = theme.black
theme.color8 = theme.black

--- Red
theme.color1 = theme.red
theme.color9 = theme.red

--- Green
theme.color2 = theme.green
theme.color10 = theme.green

--- Yellow
theme.color3 = theme.yellow
theme.color11 = theme.yellow

--- Blue
theme.color4 = theme.blue
theme.color12 = theme.blue

--- Magenta
theme.color5 = theme.magenta
theme.color13 = theme.magenta

--- Cyan
theme.color6 = theme.cyan
theme.color14 = theme.cyan

--- White
theme.color7 = theme.white
theme.color15 = theme.white

--- Background Colors
theme.bg_normal = theme.bg
theme.bg_focus = theme.bg0
theme.bg_urgent = theme.bg
theme.bg_minimize = theme.bg

--- Foreground Colors
theme.fg_normal = theme.fg
theme.fg_focus = theme.accent
theme.fg_urgent = theme.color1
theme.fg_minimize = theme.color0

--- UI events
theme.leave_event = theme.transparent
theme.enter_event = theme.white .. "10"
theme.press_event = theme.white .. "15"
theme.release_event = theme.white .. "10"

--- Widgets
theme.widget_bg = theme.dark

-- Titlebars
theme.titlebar_enabled = true
theme.titlebar_bg = theme.bg
theme.titlebar_fg = theme.fg

local icon_dir = gfs.get_configuration_dir() .. "/icons/titlebar/"

-- Close Button
theme.titlebar_close_button_normal = icon_dir .. "normal.svg"
theme.titlebar_close_button_focus = icon_dir .. "close_focus.svg"
theme.titlebar_close_button_normal_hover = icon_dir .. "close_focus_hover.svg"
theme.titlebar_close_button_focus_hover = icon_dir .. "close_focus_hover.svg"

-- Minimize Button
theme.titlebar_minimize_button_normal = icon_dir .. "normal.svg"
theme.titlebar_minimize_button_focus = icon_dir .. "minimize_focus.svg"
theme.titlebar_minimize_button_normal_hover = icon_dir .. "minimize_focus_hover.svg"
theme.titlebar_minimize_button_focus_hover = icon_dir .. "minimize_focus_hover.svg"

-- Maximized Button (While Window is Maximized)
theme.titlebar_maximized_button_normal_active = icon_dir .. "normal.svg"
theme.titlebar_maximized_button_focus_active = icon_dir .. "maximized_focus.svg"
theme.titlebar_maximized_button_normal_active_hover = icon_dir .. "maximized_focus_hover.svg"
theme.titlebar_maximized_button_focus_active_hover = icon_dir .. "maximized_focus_hover.svg"

-- Maximized Button (While Window is not Maximized)
theme.titlebar_maximized_button_normal_inactive = icon_dir .. "normal.svg"
theme.titlebar_maximized_button_focus_inactive = icon_dir .. "maximized_focus.svg"
theme.titlebar_maximized_button_normal_inactive_hover = icon_dir .. "maximized_focus_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover = icon_dir .. "maximized_focus_hover.svg"

--- Wibar
theme.wibar_bg = theme.dark
theme.wibar_height = dpi(40)

-- UI ELEMENTS
theme.random_wallpaper = function()
	local theme_dir = gfs.get_configuration_dir() .. "theme/wallpapers/"
	return gears.surface.load_uncached(theme_dir .. gfs.get_random_file_from_dir(theme_dir, { "png", "jpg" }))
end
theme.avatar = gears.surface.load_uncached(gfs.get_configuration_dir() .. "theme/assets/avatar.png")

--- Layout
theme.master_width_factor = 0.6
--- You can use your own layout icons like this:
theme.layout_floating = icons.floating
theme.layout_max = icons.max
theme.layout_tile = icons.tile
theme.layout_dwindle = icons.dwindle
theme.layout_centered = icons.centered

--- Icon Theme
--- Define the icon theme for application icons. If not set then the icons
--- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Papirus-Dark"

--- Borders
theme.border_width = dpi(0)
theme.border_color_marked = theme.blue
theme.border_color_active = theme.accent
theme.border_color_normal = theme.bg
theme.border_color_urgent = theme.red
theme.border_color_floating = theme.accent

-- Corner Radius
theme.border_radius = 0

-- Tooltip
theme.tooltip_bg = theme.bg0
theme.tooltip_fg = theme.fg
theme.tooltip_font = theme.font_name .. " Medium 11"

--- Hotkeys Pop Up
theme.hotkeys_bg = theme.black
theme.hotkeys_fg = theme.white
theme.hotkeys_modifiers_fg = theme.white
theme.hotkeys_font = theme.font_name .. "Medium 12"
theme.hotkeys_description_font = theme.font_name .. "Regular 10"
theme.hotkeys_shape = helpers.ui.rrect(theme.border_radius)
theme.hotkeys_group_margin = dpi(50)

--- Tag list
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

--- Tag preview
theme.tag_preview_widget_margin = dpi(10)
theme.tag_preview_widget_border_radius = theme.border_radius
theme.tag_preview_client_border_radius = theme.border_radius / 2
theme.tag_preview_client_opacity = 1
theme.tag_preview_client_bg = theme.wibar_bg
theme.tag_preview_client_border_color = theme.wibar_bg
theme.tag_preview_client_border_width = 0
theme.tag_preview_widget_bg = theme.wibar_bg
theme.tag_preview_widget_border_color = theme.wibar_bg
theme.tag_preview_widget_border_width = 0

--- Layout List
theme.layoutlist_shape_selected = helpers.ui.rrect(theme.border_radius)
theme.layoutlist_bg_selected = theme.widget_bg

--- Gaps
theme.useless_gap = dpi(6)

--- Systray
theme.systray_icon_size = dpi(24)
theme.systray_icon_spacing = dpi(10)
theme.bg_systray = theme.wibar_bg
--- theme.systray_max_rows = 2

--- Notifications
theme.notification_spacing = dpi(4)
theme.notification_bg = theme.dark
theme.notification_bg_alt = theme.bg0

--- Notif center
theme.notif_center_notifs_bg = theme.dark
theme.notif_center_notifs_bg_alt = theme.bg0

--- Swallowing
theme.dont_swallow_classname_list = {
	"firefox",
	"gimp",
	"Google-chrome",
	"Thunar",
}

return theme
