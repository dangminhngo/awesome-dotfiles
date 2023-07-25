local helpers = require("helpers")

local fg = "#c5d5df"
local bg = "#0d1418"

local palette = {
	colorscheme = "Crux",
	fg = fg,
	bg = bg,
	transparent = "#00000000",
	-- Accent color
	accent = "#a4c76f",
	-- Backgrounds & Foregrounds
	dark = helpers.color.relative_darken(bg, 0.32),
	bg0 = helpers.color.relative_darken(bg, 0.16),
	bg2 = helpers.color.relative_lighten(bg, 0.02),
	bg3 = helpers.color.relative_lighten(bg, 0.06),
	bg4 = helpers.color.relative_lighten(bg, 0.1),
	fg0 = helpers.color.relative_lighten(fg, 0.64),
	fg2 = helpers.color.relative_darken(fg, 0.16),
	fg3 = helpers.color.relative_darken(fg, 0.32),
	fg4 = helpers.color.relative_darken(fg, 0.48),
	-- Palette
	red = "#e46769",
	green = "#a4c76f",
	yellow = "#eace60",
	blue = "#619af5",
	magenta = "#9d78d1",
	cyan = "#42b8e6",
	teal = "#5fd7aa",
	orange = "#e39d5f",
	pink = "#d983d7",
	black = helpers.color.relative_lighten(bg, 0.2),
	gray = helpers.color.relative_lighten(bg, 0.32),
	white = helpers.color.relative_lighten(fg, 0.64),
}

return palette
