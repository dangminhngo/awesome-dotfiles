local helpers = require("helpers")

local fg = "#abc2d0"
local bg = "#10181d"

local palette = {

	fg = fg,
	bg = bg,
	transparent = "#00000000",
	-- Backgrounds & Foregrounds
	dark = helpers.color.relative_darken(bg, 0.4),
	bg0 = helpers.color.relative_darken(bg, 0.16),
	bg2 = helpers.color.relative_lighten(bg, 0.04),
	bg3 = helpers.color.relative_lighten(bg, 0.08),
	bg4 = helpers.color.relative_lighten(bg, 0.12),
	fg0 = helpers.color.relative_lighten(fg, 0.56),
	fg2 = helpers.color.relative_darken(fg, 0.16),
	fg3 = helpers.color.relative_darken(fg, 0.32),
	fg4 = helpers.color.relative_darken(fg, 0.48),
	-- Palette
	red = "#f15a5d",
	green = "#a4c76f",
	yellow = "#eace60",
	blue = "#619af5",
	magenta = "#9d78d1",
	cyan = "#42b8e6",
	teal = "#72c2b2",
	orange = "#e39d5f",
	pink = "#d983d7",
	black = helpers.color.relative_lighten(bg, 0.18),
	gray = helpers.color.relative_lighten(bg, 0.32),
	white = helpers.color.relative_lighten(fg, 0.64),
}

palette.accent = palette.green

return palette
