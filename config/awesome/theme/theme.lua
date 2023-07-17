local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local theme = dofile(themes_path .. "default/theme.lua")
local theme_assets = require("beautiful.theme_assets")
local xrs = require("beautiful.xresources")
local dpi = xrs.apply_dpi
local helpers = require("helpers")
local icons = require("icons")

-- FONTS
-- UI Fonts
theme.font_name = "Jetka"
theme.font = theme.font_name .. " Medium 11"
-- Icon Fonts
theme.icon_font = "Material Icons"

-- COLORS
theme.transparent = "#00000000"
theme.fg = "#abc2d0"
theme.bg = "#10181d"

-- Accent color
theme.accent = "#a4c76f"
-- Backgrounds & Foregrounds
theme.dark = helpers.color.relative_darken(theme.bg, 0.4)
theme.bg0 = helpers.color.relative_darken(theme.bg, 0.16)
theme.bg2 = helpers.color.relative_lighten(theme.bg, 0.04)
theme.bg3 = helpers.color.relative_lighten(theme.bg, 0.08)
theme.bg4 = helpers.color.relative_lighten(theme.bg, 0.12)
theme.fg0 = helpers.color.relative_lighten(theme.fg, 0.56)
theme.fg2 = helpers.color.relative_darken(theme.fg, 0.16)
theme.fg3 = helpers.color.relative_darken(theme.fg, 0.32)
theme.fg4 = helpers.color.relative_darken(theme.fg, 0.48)
-- Palette
theme.red = "#f15a5d"
theme.green = "#a4c76f"
theme.yellow = "#eace60"
theme.blue = "#619af5"
theme.magenta = "#9d78d1"
theme.cyan = "#42b8e6"
theme.teal = "#72c2b2"
theme.orange = "#e39d5f"
theme.pink = "#d983d7"
theme.black = helpers.color.relative_lighten(theme.bg, 0.18)
theme.gray = helpers.color.relative_lighten(theme.bg, 0.32)
theme.white = helpers.color.relative_lighten(theme.fg, 0.64)

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
theme.wallpaper = gears.surface.load_uncached(gfs.get_configuration_dir() .. "theme/assets/wallpaper.png")
theme.avatar = gears.surface.load_uncached(gfs.get_configuration_dir() .. "theme/assets/avatar.png")

--- Layout
--- You can use your own layout icons like this:
theme.layout_floating = icons.floating
theme.layout_max = icons.max
theme.layout_tile = icons.tile
theme.layout_dwindle = icons.dwindle
theme.layout_centered = icons.centered
theme.layout_mstab = icons.mstab
theme.layout_equalarea = icons.equalarea
theme.layout_machi = icons.machi

--- Icon Theme
--- Define the icon theme for application icons. If not set then the icons
--- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Papirus-Dark"

--- Borders
theme.border_width = 0

-- Corner Radius
theme.border_radius = 0

-- Tooltip
theme.tooltip_bg = theme.bg0
theme.tooltip_fg = theme.fg
theme.tooltip_font = theme.font_name .. " Regular 10"

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

--- Tabs
theme.mstab_bar_height = dpi(60)
theme.mstab_bar_padding = dpi(0)
theme.mstab_border_radius = dpi(6)
theme.mstab_bar_disable = true
theme.tabbar_disable = true
theme.tabbar_style = "modern"
theme.tabbar_bg_focus = theme.black
theme.tabbar_bg_normal = theme.color0
theme.tabbar_fg_focus = theme.color0
theme.tabbar_fg_normal = theme.color15
theme.tabbar_position = "bottom"
theme.tabbar_AA_radius = 0
theme.tabbar_size = 0
theme.mstab_bar_ontop = true

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
